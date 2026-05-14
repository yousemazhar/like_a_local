import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reminder.dart';

class ReminderRepository {
  ReminderRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _items(String uid) =>
      _db.collection('reminders').doc(uid).collection('items');

  Stream<List<Reminder>> stream(String uid) => _items(uid).snapshots().map(
    (s) => s.docs.map((d) => Reminder.fromJson(d.id, d.data())).toList()
      ..sort(
        (a, b) => (b.createdAt ?? DateTime(1970)).compareTo(
          a.createdAt ?? DateTime(1970),
        ),
      ),
  );

  Stream<bool> isSet(String uid, String placeId) =>
      _items(uid).doc(placeId).snapshots().map((d) => d.exists);

  Future<void> set({
    required String uid,
    required String placeId,
    String? placeTitle,
    int radiusMeters = 200,
  }) => _items(uid).doc(placeId).set({
    'placeId': placeId,
    'type': 'location',
    'radiusMeters': radiusMeters,
    'enabled': true,
    'placeTitle': ?placeTitle,
    'createdAt': FieldValue.serverTimestamp(),
  });

  Future<void> setEnabled(String uid, String placeId, bool enabled) => _items(
    uid,
  ).doc(placeId).set({'enabled': enabled}, SetOptions(merge: true));

  Future<void> remove(String uid, String placeId) =>
      _items(uid).doc(placeId).delete();
}
