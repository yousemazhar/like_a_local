import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/review.dart';

class ReviewRepository {
  ReviewRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _reviews(String placeId) =>
      _db.collection('places').doc(placeId).collection('reviews');

  Stream<List<Review>> reviewsStream(String placeId, {int limit = 20}) =>
      _reviews(placeId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) => s.docs
              .map((d) => Review.fromJson({...d.data(), 'id': d.id}))
              .toList());

  Stream<Review?> myReview(String placeId, String uid) => _reviews(placeId)
      .where('authorUid', isEqualTo: uid)
      .limit(1)
      .snapshots()
      .map((s) => s.docs.isEmpty
          ? null
          : Review.fromJson({...s.docs.first.data(), 'id': s.docs.first.id}));

  Future<void> upsertReview({
    required String placeId,
    required String uid,
    required String displayName,
    String? photoUrl,
    bool isSuper = false,
    required int rating,
    required String text,
  }) async {
    final col = _reviews(placeId);
    final existing =
        await col.where('authorUid', isEqualTo: uid).limit(1).get();

    final payload = {
      'placeId': placeId,
      'authorUid': uid,
      'authorDisplayName': displayName,
      'authorPhotoUrl': photoUrl,
      'authorIsSuper': isSuper,
      'rating': rating,
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (existing.docs.isEmpty) {
      await col.add({...payload, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await existing.docs.first.reference.update(payload);
    }
  }

  Future<void> deleteReview(String placeId, String reviewId) =>
      _reviews(placeId).doc(reviewId).delete();
}
