import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/place.dart';

class PlaceRepository {
  PlaceRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _places =>
      _db.collection('places');

  Stream<List<Place>> discoverFeed({int limit = 20}) => _places
      .where('hidden', isEqualTo: false)
      .orderBy('ownerIsSuper', descending: true)
      .orderBy('ownerSuperScore', descending: true)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map(_toDomain);

  Stream<List<Place>> nearbyCandidates({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 80,
  }) {
    final bounds = _coordinateBounds(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );

    return _places
        .where('lat', isGreaterThanOrEqualTo: bounds.minLat)
        .where('lat', isLessThanOrEqualTo: bounds.maxLat)
        .snapshots()
        .map((snap) {
          final places = _visiblePlaces(snap)
              .where(
                (place) =>
                    place.lng >= bounds.minLng &&
                    place.lng <= bounds.maxLng &&
                    _distanceKm(latitude, longitude, place.lat, place.lng) <=
                        radiusKm,
              )
              .toList();
          places.sort(
            (a, b) => _distanceKm(
              latitude,
              longitude,
              a.lat,
              a.lng,
            ).compareTo(_distanceKm(latitude, longitude, b.lat, b.lng)),
          );
          return places.take(limit).toList(growable: false);
        });
  }

  Stream<List<Place>> featured({int limit = 10}) => _places
      .where('hidden', isEqualTo: false)
      .where('featured', isEqualTo: true)
      .limit(limit)
      .snapshots()
      .map(_toDomain);

  Stream<List<Place>> trending({int limit = 10}) => _places
      .where('hidden', isEqualTo: false)
      .orderBy('ownerIsSuper', descending: true)
      .orderBy('saveCount', descending: true)
      .orderBy('ratingAvg', descending: true)
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
        .limit(30)
        .snapshots()
        .map((snap) => _visiblePlaces(snap).toList(growable: false));
  }

  Stream<List<Place>> byOwner(String uid) => _places
      .where('ownerUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(_toDomain);

  Future<String> createPlace(Place place) async {
    final ref = _places.doc();
    final payload = place.toJson()
      ..remove('ownerIsSuper')
      ..remove('ownerSuperScore')
      ..remove('ratingAvg')
      ..remove('ratingCount')
      ..remove('saveCount');
    await ref.set({
      ...payload,
      'id': ref.id,
      'ownerIsSuper': false,
      'ownerSuperScore': 0,
      'ratingAvg': 0,
      'ratingCount': 0,
      'saveCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'hidden': false,
    });
    return ref.id;
  }

  List<Place> _toDomain(QuerySnapshot<Map<String, dynamic>> snap) =>
      snap.docs.map(_docToPlace).toList();

  List<Place> _visiblePlaces(QuerySnapshot<Map<String, dynamic>> snap) => snap
      .docs
      .where((doc) => doc.data()['hidden'] != true)
      .map(_docToPlace)
      .toList();

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

({double minLat, double maxLat, double minLng, double maxLng})
_coordinateBounds({
  required double latitude,
  required double longitude,
  required double radiusKm,
}) {
  const kmPerLatDegree = 110.574;
  final latDelta = radiusKm / kmPerLatDegree;
  final latitudeRadians = latitude * math.pi / 180;
  final kmPerLngDegree = 111.320 * math.cos(latitudeRadians).abs();
  final lngDelta = kmPerLngDegree <= 0.000001
      ? 180.0
      : radiusKm / kmPerLngDegree;

  return (
    minLat: math.max(-90, latitude - latDelta),
    maxLat: math.min(90, latitude + latDelta),
    minLng: math.max(-180, longitude - lngDelta),
    maxLng: math.min(180, longitude + lngDelta),
  );
}

double _distanceKm(
  double latitude,
  double longitude,
  double otherLatitude,
  double otherLongitude,
) {
  const earthRadiusKm = 6371.0;
  final lat1 = latitude * math.pi / 180;
  final lat2 = otherLatitude * math.pi / 180;
  final deltaLat = (otherLatitude - latitude) * math.pi / 180;
  final deltaLng = (otherLongitude - longitude) * math.pi / 180;
  final a =
      math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(deltaLng / 2) *
          math.sin(deltaLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusKm * c;
}
