import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../domain/chat.dart';
import '../domain/chat_providers.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final threadsAsync = ref.watch(myThreadsProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text(t.inboxTitle,
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            const Divider(height: 1),
            Expanded(
              child: threadsAsync.when(
                loading: () => SkeletonList(
                  itemCount: 4,
                  itemBuilder: (_, __) => const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: SkeletonBox(width: double.infinity, height: 64),
                  ),
                ),
                error: (e, _) => ErrorView(message: '$e'),
                data: (threads) => threads.isEmpty
                    ? EmptyView(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: t.inboxEmpty,
                        body: t.inboxEmptyBody,
                      )
                    : ListView.separated(
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const Divider(
                            height: 1, indent: 76, endIndent: 0),
                        itemBuilder: (_, i) => _ThreadTile(
                          thread: threads[i],
                          currentUid: user?.uid ?? '',
                          onTap: () =>
                              context.push('/chat/${threads[i].id}'),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.currentUid,
    required this.onTap,
  });

  final ChatThread thread;
  final String currentUid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final otherUid = thread.members.firstWhere(
      (m) => m != currentUid,
      orElse: () => thread.members.isEmpty ? '' : thread.members.first,
    );
    final meta = thread.memberMeta[otherUid];
    final name =
        meta?.displayName.isNotEmpty == true ? meta!.displayName : 'Local';
    final unread = thread.unread[currentUid] ?? 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: LALColors.c100,
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: LALTypography.headlineSmall.copyWith(color: LALColors.c600),
        ),
      ),
      title: Row(
        children: [
          Expanded(child: Text(name, style: LALTypography.labelLarge)),
          if (meta?.isSuper ?? false)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: LALColors.accent,
                borderRadius: LALRadii.pillBorder,
              ),
              child: Text(
                t.chatLocalBadge,
                style: LALTypography.labelSmall
                    .copyWith(color: Colors.white, fontSize: 9),
              ),
            ),
        ],
      ),
      subtitle: Text(
        thread.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: LALTypography.bodySmall.copyWith(
          color: unread > 0 ? LALColors.c900 : LALColors.c500,
          fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: unread > 0
          ? Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: LALColors.accent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('$unread',
                    style: LALTypography.labelSmall
                        .copyWith(color: Colors.white, fontSize: 10)),
              ),
            )
          : null,
    );
  }
}
