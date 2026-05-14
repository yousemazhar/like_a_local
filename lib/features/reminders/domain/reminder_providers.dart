import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../auth/domain/auth_providers.dart';
import '../data/reminder_repository.dart';
import 'reminder.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => ReminderRepository(FirebaseFirestore.instance),
);

final remindersStreamProvider =
    StreamProvider<List<Reminder>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(const []);
  return ref.watch(reminderRepositoryProvider).stream(user.uid);
});

final isReminderSetProvider =
    StreamProvider.family<bool, String>((ref, placeId) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(false);
  return ref.watch(reminderRepositoryProvider).isSet(user.uid, placeId);
});

/// Current background location permission status. Invalidate this provider
/// whenever the app returns to the foreground to pick up permission changes.
final locationPermissionProvider = FutureProvider<LocationPermission>(
  (_) => Geolocator.checkPermission(),
);
