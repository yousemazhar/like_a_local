import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/app_notification.dart';

class NotificationRepository {
  NotificationRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _items(String uid) =>
      _db.collection('notifications').doc(uid).collection('items');

  Stream<List<AppNotification>> stream(String uid, {int limit = 50}) =>
      _items(uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) => s.docs
              .map((d) => AppNotification.fromJson({...d.data(), 'id': d.id}))
              .toList());

  Future<void> markRead(String uid, String id) =>
      _items(uid).doc(id).set({'read': true}, SetOptions(merge: true));

  Future<void> markAllRead(String uid) async {
    final unread = await _items(uid).where('read', isEqualTo: false).get();
    final batch = _db.batch();
    for (final d in unread.docs) {
      batch.set(d.reference, {'read': true}, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
