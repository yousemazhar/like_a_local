import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../auth/domain/auth_providers.dart';
import '../data/notification_repository.dart';
import 'app_notification.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(NotificationRepositoryRef ref) =>
    NotificationRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<AppNotification>> myNotifications(MyNotificationsRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(notificationRepositoryProvider).stream(user.uid);
}

@riverpod
class NotificationActions extends _$NotificationActions {
  @override
  void build() {}

  Future<void> markRead(String id) async {
    if (ref.read(isOnlineProvider).valueOrNull == false) return;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref.read(notificationRepositoryProvider).markRead(user.uid, id);
  }

  Future<void> markAllRead() async {
    if (ref.read(isOnlineProvider).valueOrNull == false) return;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref.read(notificationRepositoryProvider).markAllRead(user.uid);
  }
}
