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
        return AppUser(
          uid: authUser.uid,
          email: (data['email'] as String?) ?? authUser.email,
          displayName: data['displayName'] as String? ?? authUser.displayName,
          photoUrl: authUser.photoUrl ?? (data['photoUrl'] as String?),
          locale: data['locale'] as String? ?? 'en',
          role: data['role'] as String? ?? 'user',
          emailVerified: authUser.emailVerified,
          premium: data['premium'] as bool? ?? false,
          preferences: data['preferences'] != null
              ? UserPreferences.fromJson(
                  Map<String, dynamic>.from(data['preferences'] as Map),
                )
              : const UserPreferences(),
        );
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
        return AppUser(
          uid: uid,
          email: (data['email'] as String?) ?? '',
          displayName: data['displayName'] as String?,
          photoUrl: data['photoUrl'] as String?,
          locale: data['locale'] as String? ?? 'en',
          role: data['role'] as String? ?? 'user',
        );
      });
}
