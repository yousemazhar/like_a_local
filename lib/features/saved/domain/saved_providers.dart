import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../auth/domain/auth_providers.dart';
import '../data/saved_repository.dart';
import 'saved_pin.dart';

part 'saved_providers.g.dart';

@Riverpod(keepAlive: true)
SavedRepository savedRepository(SavedRepositoryRef ref) =>
    SavedRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<SavedPin>> savedPins(SavedPinsRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(savedRepositoryProvider).pinsStream(user.uid);
}

@riverpod
Stream<List<SavedCollection>> savedCollections(SavedCollectionsRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(savedRepositoryProvider).collectionsStream(user.uid);
}

@riverpod
Stream<bool> isPlacePinned(IsPlacePinnedRef ref, String placeId) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(false);
  return ref.watch(savedRepositoryProvider).isPinned(user.uid, placeId);
}

@riverpod
class SavedNotifier extends _$SavedNotifier {
  @override
  void build() {}

  void _ensureOnline() {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      throw const OfflineException();
    }
  }

  Future<void> togglePin(String placeId) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final repo = ref.read(savedRepositoryProvider);
    final pinned = await repo.isPinned(user.uid, placeId).first;
    if (pinned) {
      await repo.unpinPlace(user.uid, placeId);
    } else {
      await repo.pinPlace(user.uid, placeId);
    }
  }

  Future<void> createCollection(String name) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref.read(savedRepositoryProvider).createCollection(user.uid, name);
  }

  Future<void> renameCollection(String id, String name) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref
        .read(savedRepositoryProvider)
        .renameCollection(user.uid, id, name);
  }

  Future<void> deleteCollection(String id) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref.read(savedRepositoryProvider).deleteCollection(user.uid, id);
  }

  Future<void> setPinCollection(String placeId, String? collectionId) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref
        .read(savedRepositoryProvider)
        .setPinCollection(user.uid, placeId, collectionId);
  }
}

/// Pins that belong to a specific collection (or unfiled when [collectionId]
/// is null). Derived synchronously from [savedPinsProvider].
@riverpod
AsyncValue<List<SavedPin>> pinsInCollection(
  PinsInCollectionRef ref,
  String? collectionId,
) {
  return ref.watch(savedPinsProvider).whenData(
        (pins) => pins
            .where((p) => p.collectionId == collectionId)
            .toList(growable: false),
      );
}
