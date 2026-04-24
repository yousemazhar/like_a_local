import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/auth_providers.dart';

/// Locales the app supports. Keep in sync with `supportedLocales` in [App] and
/// with the `@@locale` of the ARB files in `lib/l10n/`.
const supportedLanguageCodes = <String>{'en', 'de'};

/// Clamp an arbitrary language code to a supported one, falling back to `en`.
String clampToSupported(String? code) {
  if (code == null) return 'en';
  return supportedLanguageCodes.contains(code) ? code : 'en';
}

/// Reads the device's system locale (e.g. from Android/iOS settings) and
/// maps it to one of the supported app locales.
String resolveDeviceLocale() {
  final locales = PlatformDispatcher.instance.locales;
  for (final l in locales) {
    if (supportedLanguageCodes.contains(l.languageCode)) {
      return l.languageCode;
    }
  }
  return 'en';
}

/// Single source of truth for the active UI locale.
///
/// Resolution order:
/// 1. Signed-in user's `users/{uid}.locale` from Firestore (wins when present).
/// 2. Device locale ([PlatformDispatcher.instance.locale]) clamped to
///    [supportedLanguageCodes].
///
/// Mutations go through [LocaleNotifier.setLocale], which updates the local
/// state immediately and — if a user is signed in — writes the new locale to
/// Firestore so it persists across devices.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // React to remote changes (e.g. the same user switching language on
    // another device) by watching the user doc stream.
    final userAsync = ref.watch(currentUserDocProvider);
    final remoteCode = userAsync.valueOrNull?.locale;
    if (remoteCode != null && supportedLanguageCodes.contains(remoteCode)) {
      return Locale(remoteCode);
    }
    return Locale(resolveDeviceLocale());
  }

  /// Change the active locale. Writes to Firestore when a user is signed in
  /// so the preference survives sign-outs and is shared across devices.
  Future<void> setLocale(String code) async {
    final clamped = clampToSupported(code);
    state = Locale(clamped);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'locale': clamped});
      } catch (_) {
        // Swallow — offline persistence will flush when back online.
      }
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
