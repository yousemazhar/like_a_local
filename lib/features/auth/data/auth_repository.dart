import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/app_user.dart';

void _printGoogleSignInFailure(Object error, StackTrace stackTrace) {
  print('Google sign-in failed.');
  print('Google sign-in error runtimeType: ${error.runtimeType}');
  print('Google sign-in error toString: $error');

  if (error is PlatformException) {
    print('Google sign-in PlatformException code: ${error.code}');
    print('Google sign-in PlatformException message: ${error.message}');
    print('Google sign-in PlatformException details: ${error.details}');
  }

  print('Google sign-in stackTrace: $stackTrace');
}

class AuthRepository {
  AuthRepository(this._auth, this._db, this._googleSignIn);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  // GoogleSignIn should be instantiated with the Web OAuth client ID from
  // Firebase google-services.json (`client_type: 3`), not the Android OAuth
  // client ID. Android builds also need app signing SHA-1/SHA-256 fingerprints
  // registered in Firebase, otherwise account selection can succeed and token
  // exchange can fail after returning to MainActivity.
  final GoogleSignIn _googleSignIn;

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
      'locale': resolveDeviceLocale(),
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

  /// Signs in with Google. Returns null if the user cancelled the flow.
  Future<AppUser?> signInWithGoogle() async {
    // Always show the account picker so the user can switch accounts.
    await _googleSignIn.signOut();

      final googleUser = await (() async {
        try {
          return await _googleSignIn.signIn();
        } catch (e, stackTrace) {
          _printGoogleSignInFailure(e, stackTrace);
          rethrow;
        }
      })();
      if (googleUser == null) {
        print('Google sign-in returned null: user cancelled account picker.');
      } else {
        print(
          'Google sign-in returned account: ${googleUser.email} '
          '(${googleUser.id}).',
        );
      }
    if (googleUser == null) return null; // user cancelled

      final googleAuth = await (() async {
        try {
          return await googleUser.authentication;
        } catch (e, stackTrace) {
          _printGoogleSignInFailure(e, stackTrace);
          rethrow;
        }
      })();
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    final user = cred.user!;

    // Upsert Firestore user doc (only on first sign-in via additionalUserInfo)
    final isNew = cred.additionalUserInfo?.isNewUser ?? false;
    if (isNew) {
      await _db.collection('users').doc(user.uid).set({
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'locale': resolveDeviceLocale(),
        'role': 'user',
        'emailVerified': true,
        'preferences': {
          'placeTypes': [],
          'moods': [],
        },
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return _enrichUser(user);
  }

  /// Signs out from both FirebaseAuth and GoogleSignIn so the account picker
  /// is always shown on the next sign-in attempt.
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

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
          premium: data['premium'] as bool? ?? false,
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

  static String friendlyAuthError(Object e, BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (e is FirebaseAuthException) {
      return switch (e.code) {
        'user-not-found' || 'wrong-password' || 'invalid-credential' =>
          t.authErrorInvalidCredential,
        'email-already-in-use' => t.authErrorEmailInUse,
        'weak-password' => t.authErrorWeakPassword,
        'invalid-email' => t.authErrorInvalidEmail,
        'network-request-failed' => t.authErrorNoInternet,
        _ => t.authErrorSignInFailed,
      };
    }
    return t.authErrorSignInFailed;
  }
}
