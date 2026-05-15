import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../auth/domain/app_user.dart';
import '../../place/domain/place.dart' hide TimestampConverter;

class SuperUserRepository {
  SuperUserRepository(this._db, [FirebaseFunctions? functions])
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  Stream<List<AppUser>> leaderboard({int limit = 50}) => _db
      .collection('users')
      .where('role', isEqualTo: 'super')
      .snapshots()
      .map((snap) {
        final users = snap.docs
            .map((doc) => _userFromDoc(doc.id, doc.data()))
            .toList(growable: false);
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

  Future<int> recalculateAllScores() async {
    try {
      final callable = _functions.httpsCallable('recalculateAllSuperUserRanks');
      final result = await callable.call<Map<String, dynamic>>();
      return (result.data['userCount'] as num?)?.toInt() ?? 0;
    } on FirebaseFunctionsException catch (error) {
      throw SuperUserRecalculationException(
        error.message ?? error.code,
      );
    }
  }

  Stream<List<Place>> placesByUser(String uid) {
    if (uid.isEmpty) return Stream.value(const []);
    return _db
        .collection('places')
        .where('ownerUid', isEqualTo: uid)
        .snapshots()
        .map((snap) {
          final places = snap.docs
              .where((doc) => doc.data()['hidden'] != true)
              .map((doc) => Place.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false);
          places.sort((a, b) {
            final aCreatedAt =
                a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bCreatedAt =
                b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bCreatedAt.compareTo(aCreatedAt);
          });
          return places;
        });
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

class SuperUserRecalculationException implements Exception {
  const SuperUserRecalculationException(this.message);

  final String message;

  @override
  String toString() => message;
}
