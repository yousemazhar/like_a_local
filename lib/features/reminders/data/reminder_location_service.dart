import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../notifications/data/fcm_service.dart';
import '../../notifications/data/notification_repository.dart';
import '../domain/reminder.dart';

/// Monitors the user's physical location and fires a local notification
/// (+ Firestore inbox entry) when they enter the radius of a saved reminder.
///
/// Start once after login; stop on logout.
class ReminderLocationService {
  ReminderLocationService._();
  static final instance = ReminderLocationService._();

  StreamSubscription<Position>? _positionSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _reminderSub;
  List<Reminder> _reminders = [];

  // Tracks the last time a notification fired per placeId to avoid spam.
  final Map<String, DateTime> _lastFired = {};
  static const _cooldown = Duration(hours: 1);

  Future<void> start(String uid) async {
    if (_positionSub != null) return;

    _reminderSub = FirebaseFirestore.instance
        .collection('reminders')
        .doc(uid)
        .collection('items')
        .snapshots()
        .listen((snap) {
      _reminders = snap.docs
          .map((d) => Reminder.fromJson(d.id, d.data()))
          .where((r) => r.enabled && r.lat != 0.0 && r.lng != 0.0)
          .toList();
    });

    final hasPermission = await _ensureBackgroundPermission();
    if (!hasPermission) return;

    final settings = _buildLocationSettings();
    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen(
          (pos) => _checkProximity(uid, pos),
          onError: (Object e) => debugPrint('ReminderLocationService error: $e'),
        );
  }

  Future<void> stop() async {
    await _positionSub?.cancel();
    await _reminderSub?.cancel();
    _positionSub = null;
    _reminderSub = null;
    _reminders = [];
    _lastFired.clear();
  }

  // ─── private ─────────────────────────────────────────────────────────────

  Future<bool> _ensureBackgroundPermission() async {
    try {
      var perm = await Geolocator.checkPermission();

      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return false;
      }

      // On Android 10+ we must separately request "always" permission
      // after the user has already granted "while in use".
      if (Platform.isAndroid && perm == LocationPermission.whileInUse) {
        perm = await Geolocator.requestPermission();
      }

      return perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('ReminderLocationService permission error: $e');
      return false;
    }
  }

  LocationSettings _buildLocationSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
        intervalDuration: const Duration(seconds: 30),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'LikeALocal',
          notificationText: 'Watching for nearby saved places…',
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
        activityType: ActivityType.other,
        pauseLocationUpdatesAutomatically: false,
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 50,
    );
  }

  void _checkProximity(String uid, Position pos) {
    final now = DateTime.now();
    for (final r in _reminders) {
      final last = _lastFired[r.placeId];
      if (last != null && now.difference(last) < _cooldown) continue;

      final distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        r.lat,
        r.lng,
      );

      if (distance <= r.radiusMeters) {
        _lastFired[r.placeId] = now;
        final title = r.placeTitle ?? 'Saved place';
        _fire(uid, r.placeId, title);
      }
    }
  }

  Future<void> _fire(String uid, String placeId, String placeTitle) async {
    try {
      await FcmService.instance.showLocal(
        placeId.hashCode,
        'You\'re near $placeTitle',
        'Your reminder for $placeTitle is active.',
      );
      await NotificationRepository(FirebaseFirestore.instance)
          .writeProximityNotification(
        uid: uid,
        placeId: placeId,
        placeTitle: placeTitle,
      );
    } catch (e) {
      debugPrint('ReminderLocationService._fire error: $e');
    }
  }
}
