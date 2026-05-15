import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/app_user.dart';
import '../../place/domain/place.dart';
import '../data/super_user_repository.dart';

part 'super_user_providers.g.dart';

@Riverpod(keepAlive: true)
SuperUserRepository superUserRepository(SuperUserRepositoryRef ref) =>
    SuperUserRepository(FirebaseFirestore.instance, FirebaseFunctions.instance);

@riverpod
Stream<List<AppUser>> superUsers(SuperUsersRef ref) =>
    ref.watch(superUserRepositoryProvider).leaderboard();

@riverpod
Stream<AppUser?> publicUser(PublicUserRef ref, String uid) =>
    ref.watch(superUserRepositoryProvider).user(uid);

@riverpod
Stream<List<Place>> publicUserPlaces(PublicUserPlacesRef ref, String uid) =>
    ref.watch(superUserRepositoryProvider).placesByUser(uid);
