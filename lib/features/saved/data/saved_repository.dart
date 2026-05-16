import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/saved_pin.dart';

class SavedRepository {
  SavedRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _pins(String uid) =>
      _db.collection('saves').doc(uid).collection('pins');

  CollectionReference<Map<String, dynamic>> _collections(String uid) =>
      _db.collection('saves').doc(uid).collection('collections');

  Stream<List<SavedPin>> pinsStream(String uid) => _pins(uid)
      .orderBy('pinnedAt', descending: true)
      .snapshots()
      .map((s) => s.docs
          .map((d) => SavedPin.fromJson({...d.data(), 'placeId': d.id}))
          .toList());

  Stream<List<SavedCollection>> collectionsStream(String uid) =>
      _collections(uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs
              .map((d) => SavedCollection.fromJson({...d.data(), 'id': d.id}))
              .toList());

  Stream<bool> isPinned(String uid, String placeId) =>
      _pins(uid).doc(placeId).snapshots().map((d) => d.exists);

  Future<void> pinPlace(
    String uid,
    String placeId, {
    String? collectionId,
    String? note,
  }) =>
      _pins(uid).doc(placeId).set({
        'collectionId': collectionId,
        'note': note,
        'pinnedAt': FieldValue.serverTimestamp(),
      });

  Future<void> unpinPlace(String uid, String placeId) =>
      _pins(uid).doc(placeId).delete();

  Future<String> createCollection(String uid, String name) async {
    final ref = _collections(uid).doc();
    await ref.set({
      'id': ref.id,
      'name': name,
      'count': 0,
      'isPinned': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> renameCollection(String uid, String id, String name) =>
      _collections(uid).doc(id).update({'name': name});

  /// Deletes the collection doc and clears `collectionId` on every pin
  /// that referenced it, in a single batch.
  Future<void> deleteCollection(String uid, String id) async {
    final affected =
        await _pins(uid).where('collectionId', isEqualTo: id).get();
    final batch = _db.batch();
    for (final doc in affected.docs) {
      batch.update(doc.reference, {'collectionId': null});
    }
    batch.delete(_collections(uid).doc(id));
    await batch.commit();
  }

  /// Move (or remove) a pinned place from a collection. Pass `null` to clear.
  /// Place must already be pinned.
  Future<void> setPinCollection(
    String uid,
    String placeId,
    String? collectionId,
  ) =>
      _pins(uid).doc(placeId).update({'collectionId': collectionId});
}
