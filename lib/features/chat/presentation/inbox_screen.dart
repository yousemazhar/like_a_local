import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
            Expanded(child: _ThreadList()),
          ],
        ),
      ),
    );
  }
}

class _ThreadList extends StatelessWidget {
  // TODO: Replace with Firestore stream of chat threads
  static const _threads = [
    (
      name: 'João Silva',
      lastMessage: 'The pasteis are amazing, trust me!',
      time: '2m ago',
      unread: 2,
      isSuper: true,
      isOnline: true,
    ),
    (
      name: 'Ana Costa',
      lastMessage: 'Sure, happy to help with recommendations.',
      time: '1h ago',
      unread: 0,
      isSuper: false,
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (_threads.isEmpty) {
      return EmptyView(
        icon: Icons.chat_bubble_outline_rounded,
        title: t.inboxEmpty,
        body: t.inboxEmptyBody,
      );
    }

    return ListView.separated(
      itemCount: _threads.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 76, endIndent: 0),
      itemBuilder: (_, i) {
        final thread = _threads[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: LALColors.c100,
                child: Text(
                  thread.name[0],
                  style: LALTypography.headlineSmall
                      .copyWith(color: LALColors.c600),
                ),
              ),
              if (thread.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: LALColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: LALColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Text(thread.name, style: LALTypography.labelLarge),
              const SizedBox(width: 6),
              if (thread.isSuper)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
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
              const Spacer(),
              Text(thread.time, style: LALTypography.bodySmall),
            ],
          ),
          subtitle: Text(
            thread.lastMessage,
            style: LALTypography.bodySmall.copyWith(
              color: thread.unread > 0 ? LALColors.c900 : LALColors.c500,
              fontWeight:
                  thread.unread > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: thread.unread > 0
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: LALColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${thread.unread}',
                      style: LALTypography.labelSmall
                          .copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
              : null,
          onTap: () => context.push('/chat/thread-$i'),
        );
      },
    );
  }
}
