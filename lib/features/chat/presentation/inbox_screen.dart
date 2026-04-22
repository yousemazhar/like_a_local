import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text('Inbox',
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
    if (_threads.isEmpty) {
      return const EmptyView(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No messages yet',
        body: 'Start a conversation with a local contributor.',
      );
    }

    return ListView.separated(
      itemCount: _threads.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 76, endIndent: 0),
      itemBuilder: (_, i) {
        final t = _threads[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: LALColors.c100,
                child: Text(
                  t.name[0],
                  style: LALTypography.headlineSmall
                      .copyWith(color: LALColors.c600),
                ),
              ),
              if (t.isOnline)
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
              Text(t.name, style: LALTypography.labelLarge),
              const SizedBox(width: 6),
              if (t.isSuper)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: LALColors.accent,
                    borderRadius: LALRadii.pillBorder,
                  ),
                  child: Text(
                    'LOCAL',
                    style: LALTypography.labelSmall
                        .copyWith(color: Colors.white, fontSize: 9),
                  ),
                ),
              const Spacer(),
              Text(t.time, style: LALTypography.bodySmall),
            ],
          ),
          subtitle: Text(
            t.lastMessage,
            style: LALTypography.bodySmall.copyWith(
              color: t.unread > 0 ? LALColors.c900 : LALColors.c500,
              fontWeight:
                  t.unread > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: t.unread > 0
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: LALColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${t.unread}',
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
