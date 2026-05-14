import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/app_notification.dart';
import '../domain/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _iconForType(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      case 'pin_near':
        return Icons.location_on_outlined;
      case 'badge':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final notifAsync = ref.watch(myNotificationsProvider);

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.notificationsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (ref.read(isOnlineProvider).valueOrNull == false) {
                showOfflineActionSnackBar(context);
                return;
              }
              ref.read(notificationActionsProvider.notifier).markAllRead();
            },
            child: Text(t.notificationsMarkAllRead),
          ),
        ],
      ),
      body: notifAsync.when(
        loading: () => SkeletonList(
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SkeletonBox(width: double.infinity, height: 64),
          ),
        ),
        error: (e, _) => ErrorView(message: '$e'),
        data: (items) {
          if (items.isEmpty) {
            return EmptyView(
              icon: Icons.notifications_none_rounded,
              title: t.notificationsEmpty,
              body: t.notificationsEmptyBody,
            );
          }
          final today = <AppNotification>[];
          final earlier = <AppNotification>[];
          final cutoff = DateTime.now().subtract(const Duration(hours: 24));
          for (final n in items) {
            if ((n.createdAt ?? DateTime.now()).isAfter(cutoff)) {
              today.add(n);
            } else {
              earlier.add(n);
            }
          }
          return ListView(
            children: [
              if (today.isNotEmpty) ...[
                _GroupHeader(t.notificationsToday),
                for (final n in today)
                  _NotificationTile(
                    notification: n,
                    icon: _iconForType(n.type),
                    onTap: () {
                      if (ref.read(isOnlineProvider).valueOrNull == false) {
                        showOfflineActionSnackBar(context);
                        return;
                      }
                      ref
                          .read(notificationActionsProvider.notifier)
                          .markRead(n.id);
                    },
                  ),
              ],
              if (earlier.isNotEmpty) ...[
                _GroupHeader(t.notificationsEarlier),
                for (final n in earlier)
                  _NotificationTile(
                    notification: n,
                    icon: _iconForType(n.type),
                    onTap: () {
                      if (ref.read(isOnlineProvider).valueOrNull == false) {
                        showOfflineActionSnackBar(context);
                        return;
                      }
                      ref
                          .read(notificationActionsProvider.notifier)
                          .markRead(n.id);
                    },
                  ),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
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
        style: LALTypography.labelSmall.copyWith(
          color: LALColors.c500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.onTap,
  });

  final AppNotification notification;
  final IconData icon;
  final VoidCallback onTap;

  String _relativeTime(DateTime? time) {
    if (time == null) return '';
    final delta = DateTime.now().difference(time);
    if (delta.inMinutes < 1) return 'now';
    if (delta.inHours < 1) return '${delta.inMinutes}m';
    if (delta.inDays < 1) return '${delta.inHours}h';
    return '${delta.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.read
            ? null
            : LALColors.accentSoft.withValues(alpha: 0.3),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: notification.read
                  ? LALColors.surfaceAlt
                  : LALColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: notification.read ? LALColors.c500 : LALColors.accent,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: LALTypography.labelLarge.copyWith(
              fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                notification.body,
                style: LALTypography.bodySmall,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                _relativeTime(notification.createdAt),
                style: LALTypography.bodySmall,
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
