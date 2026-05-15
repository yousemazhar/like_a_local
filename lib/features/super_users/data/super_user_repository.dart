import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';
import '../../place/domain/place.dart' hide TimestampConverter;

class SuperUserRepository {
  SuperUserRepository(this._db);

  final FirebaseFirestore _db;

  Stream<List<AppUser>> leaderboard({int limit = 50}) => _db
      .collection('users')
      .where('role', isEqualTo: 'super')
      .snapshots()
      .map((snap) {
        final users = snap.docs
            .map((doc) => _userFromDoc(doc.id, doc.data()))
            .toList();
        users.sort((a, b) => b.superUserScore.compareTo(a.superUserScore));
        return users.take(limit).toList(growable: false);
      });

  Stream<AppUser?> user(String uid) {
    if (uid.isEmpty) return Stream.value(null);
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return _userFromDoc(doc.id, data);
    });
  }

  Stream<List<Place>> placesByUser(String uid) {
    if (uid.isEmpty) return Stream.value(const []);
    return _db
        .collection('places')
        .where('ownerUid', isEqualTo: uid)
        .where('hidden', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Place.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  AppUser _userFromDoc(String uid, Map<String, dynamic> data) => AppUser(
    uid: uid,
    email: data['email'] as String? ?? '',
    displayName: data['displayName'] as String?,
    photoUrl: data['photoUrl'] as String?,
    locale: data['locale'] as String? ?? 'en',
    role: data['role'] as String? ?? 'user',
    emailVerified: data['emailVerified'] as bool? ?? false,
    premium: data['premium'] as bool? ?? false,
    superUserScore: (data['superUserScore'] as num?)?.toDouble() ?? 0,
    superUserStats: data['superUserStats'] != null
        ? SuperUserStats.fromJson(
            Map<String, dynamic>.from(data['superUserStats'] as Map),
          )
        : const SuperUserStats(),
    superUserBecameAt: const TimestampConverter().fromJson(
      data['superUserBecameAt'],
    ),
    superUserScoreUpdatedAt: const TimestampConverter().fromJson(
      data['superUserScoreUpdatedAt'],
    ),
    preferences: data['preferences'] != null
        ? UserPreferences.fromJson(
            Map<String, dynamic>.from(data['preferences'] as Map),
          )
        : const UserPreferences(),
  );
}
