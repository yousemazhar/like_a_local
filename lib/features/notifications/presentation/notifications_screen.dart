import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _todayNotifications = [
    (
      icon: Icons.chat_bubble_outline_rounded,
      title: 'João replied to your message',
      body: '"The bacalhau à brás — it\'s off-menu but…"',
      time: '2m ago',
      read: false,
    ),
    (
      icon: Icons.location_on_outlined,
      title: 'You\'re near Tasca do Chico',
      body: 'You set a reminder for this place.',
      time: '1h ago',
      read: true,
    ),
  ];

  static const _earlierNotifications = [
    (
      icon: Icons.workspace_premium_rounded,
      title: 'You unlocked Curator!',
      body: 'You\'ve shared 5 places. Super Local status coming soon.',
      time: 'Yesterday',
      read: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: _todayNotifications.isEmpty && _earlierNotifications.isEmpty
          ? const EmptyView(
              icon: Icons.notifications_none_rounded,
              title: 'You\'re all caught up',
              body: 'New notifications will appear here.',
            )
          : ListView(
              children: [
                if (_todayNotifications.isNotEmpty) ...[
                  _GroupHeader('Today'),
                  for (final n in _todayNotifications)
                    _NotificationTile(notification: n),
                ],
                if (_earlierNotifications.isNotEmpty) ...[
                  _GroupHeader('Earlier'),
                  for (final n in _earlierNotifications)
                    _NotificationTile(notification: n),
                ],
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: LALTypography.labelSmall
            .copyWith(color: LALColors.c500, letterSpacing: 0.8),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final ({
    IconData icon,
    String title,
    String body,
    String time,
    bool read,
  }) notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.read ? null : LALColors.accentSoft.withOpacity(0.3),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: notification.read ? LALColors.surfaceAlt : LALColors.accentSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.icon,
            color: notification.read ? LALColors.c500 : LALColors.accent,
            size: 20,
          ),
        ),
        title: Text(notification.title,
            style: LALTypography.labelLarge
                .copyWith(fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(notification.body,
                style: LALTypography.bodySmall, maxLines: 2),
            const SizedBox(height: 4),
            Text(notification.time, style: LALTypography.bodySmall),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
