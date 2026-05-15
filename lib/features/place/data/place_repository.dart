import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/place.dart';

class PlaceRepository {
  PlaceRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _places =>
      _db.collection('places');

  Stream<List<Place>> discoverFeed({int limit = 20}) => _places
      .where('hidden', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map(_toDomain);

  Stream<List<Place>> featured({int limit = 10}) => _places
      .where('hidden', isEqualTo: false)
      .where('featured', isEqualTo: true)
      .limit(limit)
      .snapshots()
      .map(_toDomain);

  Stream<List<Place>> trending({int limit = 10}) => _places
      .where('hidden', isEqualTo: false)
      .orderBy('saveCount', descending: true)
      .limit(limit)
      .snapshots()
      .map(_toDomain);

  Stream<Place?> placeById(String id) =>
      _places.doc(id).snapshots().map((d) => d.exists ? _docToPlace(d) : null);

  Stream<List<Place>> search(String query) {
    if (query.length < 2) return const Stream.empty();
    return _places
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .where('hidden', isEqualTo: false)
        .limit(30)
        .snapshots()
        .map(_toDomain);
  }

  Stream<List<Place>> byOwner(String uid) => _places
      .where('ownerUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(_toDomain);

  Future<String> createPlace(Place place) async {
    final ref = _places.doc();
    await ref.set({
      ...place.toJson(),
      'id': ref.id,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'saveCount': 0,
      'ratingAvg': 0.0,
      'ratingCount': 0,
      'hidden': false,
    });
    return ref.id;
  }

  List<Place> _toDomain(QuerySnapshot<Map<String, dynamic>> snap) =>
      snap.docs.map(_docToPlace).toList();

  Place _docToPlace(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = {...doc.data()!, 'id': doc.id};
    data['mediaUrls'] = _normalisedMediaUrls(data);
    return Place.fromJson(data);
  }

  List<String> _normalisedMediaUrls(Map<String, dynamic> data) {
    final mediaUrls = data['mediaUrls'];
    if (mediaUrls is List && mediaUrls.isNotEmpty) {
      return mediaUrls.whereType<String>().where((u) => u.isNotEmpty).toList();
    }

    final legacyLists = [data['photoUrls'], data['photos']];
    for (final value in legacyLists) {
      if (value is List && value.isNotEmpty) {
        return value.whereType<String>().where((u) => u.isNotEmpty).toList();
      }
    }

    final legacySingles = [
      data['imageUrl'],
      data['thumbnailUrl'],
      data['coverImage'],
      data['coverImageUrl'],
    ];
    return legacySingles
        .whereType<String>()
        .where((u) => u.isNotEmpty)
        .toList();
  }
}
