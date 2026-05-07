import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Manages FCM permission, token retrieval, and persistence to
/// `users/{uid}.fcmTokens` (array of unique device tokens).
///
/// Call [register] once after the user is authenticated.
class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  bool _registered = false;

  Future<void> register() async {
    if (_registered) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

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
}
