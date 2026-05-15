import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import 'app_user.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(GoogleSignInRef ref) => GoogleSignIn();

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(
  FirebaseAuth.instance,
  FirebaseFirestore.instance,
  ref.watch(googleSignInProvider),
);

@Riverpod(keepAlive: true)
Stream<AppUser?> authState(AuthStateRef ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;

@Riverpod(keepAlive: true)
Stream<AppUser?> currentUserDoc(CurrentUserDocRef ref) {
  final authAsync = ref.watch(authStateProvider);
  final authUser = authAsync.valueOrNull;
  if (authUser == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(authUser.uid)
      .snapshots()
      .map((snap) {
        final data = snap.data();
        if (data == null) return authUser;
        return _userFromFirestore(authUser.uid, data, fallback: authUser);
      });
}

/// Public-ish profile lookup for any uid. Used to render owner/author
/// names instead of denormalizing them onto every document.
@riverpod
Stream<AppUser?> userById(UserByIdRef ref, String uid) {
  if (uid.isEmpty) return Stream.value(null);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snap) {
        final data = snap.data();
        if (data == null) return null;
        return _userFromFirestore(uid, data);
      });
}

AppUser _userFromFirestore(
  String uid,
  Map<String, dynamic> data, {
  AppUser? fallback,
}) {
  return AppUser(
    uid: uid,
    email: (data['email'] as String?) ?? fallback?.email ?? '',
    displayName: data['displayName'] as String? ?? fallback?.displayName,
    photoUrl: data['photoUrl'] as String? ?? fallback?.photoUrl,
    locale: data['locale'] as String? ?? fallback?.locale ?? 'en',
    role: data['role'] as String? ?? fallback?.role ?? 'user',
    emailVerified:
        (data['emailVerified'] as bool?) ?? fallback?.emailVerified ?? false,
    premium: data['premium'] as bool? ?? fallback?.premium ?? false,
    superUserScore:
        ((data['superUserScore'] as num?)?.toDouble()) ??
        fallback?.superUserScore ??
        0,
    superUserStats: data['superUserStats'] != null
        ? SuperUserStats.fromJson(
            Map<String, dynamic>.from(data['superUserStats'] as Map),
          )
        : fallback?.superUserStats ?? const SuperUserStats(),
    superUserBecameAt: const TimestampConverter().fromJson(
      data['superUserBecameAt'],
    ),
    superUserScoreUpdatedAt: const TimestampConverter().fromJson(
      data['superUserScoreUpdatedAt'],
    ),
    preferences: data['preferences'] != null
        ? UserPreferences.fromJson(
            Map<String, dynamic>.from(data['preferences'] as Map),
          )
        : fallback?.preferences ?? const UserPreferences(),
  );
}
