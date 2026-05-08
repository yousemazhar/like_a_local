import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Manages FCM permission, token retrieval, and persistence to
/// `users/{uid}.fcmTokens` (array of unique device tokens).
///
/// Also bridges foreground messages to `flutter_local_notifications` so a
/// system-tray notification appears even when the app is open — without this,
/// Android only displays FCM notifications when the app is in the background.
///
/// Call [register] once after the user is authenticated.
class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'lal_default';
  static const _channelName = 'LikeALocal';
  static const _channelDescription =
      'Chat, reminders, and system notifications';

  bool _registered = false;
  bool _localReady = false;

  Future<void> _ensureLocalReady() async {
    if (_localReady) return;
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    if (Platform.isAndroid) {
      final android = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ));
      // Android 13+ runtime permission for posting notifications.
      await android?.requestNotificationsPermission();
    }
    _localReady = true;
  }

  Future<void> register() async {
    if (_registered) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _ensureLocalReady();

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      // Foreground messages: surface them via local notifications so the
      // user sees them in the system tray.
      FirebaseMessaging.onMessage.listen(_showForeground);

      String? token;
      if (Platform.isIOS) {
        await messaging.getAPNSToken();
      }
      token = await messaging.getToken();
      if (token == null || token.isEmpty) return;

      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await ref.set({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      messaging.onTokenRefresh.listen((newToken) async {
        await ref.set({
          'fcmTokens': FieldValue.arrayUnion([newToken]),
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      _registered = true;
    } catch (e, st) {
      debugPrint('FcmService.register failed: $e\n$st');
    }
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final notif = message.notification;
    final title = notif?.title ?? message.data['title'] as String? ?? 'LikeALocal';
    final body = notif?.body ?? message.data['body'] as String? ?? '';
    if (title.isEmpty && body.isEmpty) return;
    await _ensureLocalReady();
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
    );
  }
}
