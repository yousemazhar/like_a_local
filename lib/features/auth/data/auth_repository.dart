import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/app_user.dart';

class AuthRepository {
  AuthRepository(this._auth, this._db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        return _enrichUser(user);
      });

  AppUser? get currentUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return _fromFirebaseUser(u);
  }

  Future<AppUser> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _enrichUser(cred.user!);
  }

  Future<AppUser> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user!.updateDisplayName(displayName.trim());

    await _db.collection('users').doc(cred.user!.uid).set({
      'displayName': displayName.trim(),
      'email': email.trim(),
      'locale': 'en',
      'role': 'user',
      'emailVerified': false,
      'preferences': {
        'placeTypes': [],
        'moods': [],
      },
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _fromFirebaseUser(cred.user!);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> updatePreferences(
    String uid,
    UserPreferences prefs,
  ) => _db.collection('users').doc(uid).update({
        'preferences': prefs.toJson(),
      });

  Future<AppUser> _enrichUser(User user) async {
    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: data['displayName'] as String? ?? user.displayName,
          photoUrl: user.photoURL,
          locale: data['locale'] as String? ?? 'en',
          role: data['role'] as String? ?? 'user',
          emailVerified: user.emailVerified,
          preferences: data['preferences'] != null
              ? UserPreferences.fromJson(
                  Map<String, dynamic>.from(data['preferences'] as Map))
              : const UserPreferences(),
        );
      }
    } catch (_) {}
    return _fromFirebaseUser(user);
  }

  AppUser _fromFirebaseUser(User user) => AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        emailVerified: user.emailVerified,
      );

  static String friendlyAuthError(Object e) {
    if (e is FirebaseAuthException) {
      return switch (e.code) {
        'user-not-found' || 'wrong-password' || 'invalid-credential' =>
          'Email or password is incorrect.',
        'email-already-in-use' => 'This email is already registered.',
        'weak-password' => 'Password must be at least 6 characters.',
        'invalid-email' => 'Please enter a valid email address.',
        'network-request-failed' =>
          'No internet connection. Please try again.',
        _ => 'Sign in failed. Please try again.',
      };
    }
    return 'Something went wrong. Please try again.';
  }
}
