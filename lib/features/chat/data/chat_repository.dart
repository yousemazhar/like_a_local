import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/chat.dart';

class ChatRepository {
  ChatRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _db.collection('chats');

  CollectionReference<Map<String, dynamic>> _messages(String threadId) =>
      _chats.doc(threadId).collection('messages');

  Stream<List<ChatThread>> threadsForUser(String uid) => _chats
      .where('members', arrayContains: uid)
      .orderBy('lastAt', descending: true)
      .snapshots()
      .map(
        (s) => s.docs
            .map((d) => ChatThread.fromJson({...d.data(), 'id': d.id}))
            .toList(),
      );

  Stream<ChatThread?> thread(String threadId) => _chats
      .doc(threadId)
      .snapshots()
      .map(
        (d) =>
            d.exists ? ChatThread.fromJson({...d.data()!, 'id': d.id}) : null,
      );

  Stream<List<ChatMessage>> messages(String threadId, {int limit = 100}) =>
      _messages(threadId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (s) => s.docs.reversed
                .map((d) => ChatMessage.fromJson({...d.data(), 'id': d.id}))
                .toList(),
          );

  Future<String> ensureThread({
    required String currentUid,
    required String currentDisplayName,
    String? currentPhotoUrl,
    required String otherUid,
    required String otherDisplayName,
    String? otherPhotoUrl,
    bool otherIsSuper = false,
    String? placeContext,
  }) async {
    final threadId = chatThreadId(currentUid, otherUid);
    final ref = _chats.doc(threadId);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'members': [currentUid, otherUid],
        'memberMeta': {
          currentUid: {
            'displayName': currentDisplayName,
            'photoUrl': currentPhotoUrl,
            'isSuper': false,
          },
          otherUid: {
            'displayName': otherDisplayName,
            'photoUrl': otherPhotoUrl,
            'isSuper': otherIsSuper,
          },
        },
        'lastMessage': '',
        'lastAt': FieldValue.serverTimestamp(),
        'unread': {currentUid: 0, otherUid: 0},
        'placeContext': ?placeContext,
      });
    }
    return threadId;
  }

  Future<void> sendMessage({
    required String threadId,
    required String senderUid,
    required String recipientUid,
    required String text,
  }) async {
    final batch = _db.batch();
    final msgRef = _messages(threadId).doc();
    batch.set(msgRef, {
      'senderUid': senderUid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'readBy': [senderUid],
    });
    batch.update(_chats.doc(threadId), {
      'lastMessage': text,
      'lastAt': FieldValue.serverTimestamp(),
      'unread.$recipientUid': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> markRead(String threadId, String uid) =>
      _chats.doc(threadId).update({'unread.$uid': 0});
}
