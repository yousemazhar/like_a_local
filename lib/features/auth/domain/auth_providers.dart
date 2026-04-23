import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import 'app_user.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    );

@Riverpod(keepAlive: true)
Stream<AppUser?> authState(AuthStateRef ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;
