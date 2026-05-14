import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/chat.dart';

enum ChatAvailability { available, disabled, away, outsideSchedule }

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

  /// Checks whether [ownerUid] is currently available for chat.
  Future<ChatAvailability> checkOwnerAvailability(String ownerUid) async {
    final doc = await _db.collection('users').doc(ownerUid).get();
    final chatSettings =
        (doc.data()?['chatSettings'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    final enabled = (chatSettings['enabled'] as bool?) ?? true;
    if (!enabled) return ChatAvailability.disabled;

    final awayMode = (chatSettings['awayMode'] as bool?) ?? false;
    if (awayMode) return ChatAvailability.away;

    final scheduleEnabled = (chatSettings['scheduleEnabled'] as bool?) ?? false;
    if (!scheduleEnabled) return ChatAvailability.available;

    final now = DateTime.now();
    final dayKey = '${now.weekday}';
    final schedule =
        (chatSettings['schedule'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final daySlot = (schedule[dayKey] as Map?)?.cast<String, dynamic>();

    if (daySlot == null) return ChatAvailability.outsideSchedule;

    final dayEnabled = (daySlot['enabled'] as bool?) ?? false;
    if (!dayEnabled) return ChatAvailability.outsideSchedule;

    final fromHour = (daySlot['fromHour'] as int?) ?? 0;
    final fromMin = (daySlot['fromMinute'] as int?) ?? 0;
    final toHour = (daySlot['toHour'] as int?) ?? 23;
    final toMin = (daySlot['toMinute'] as int?) ?? 59;

    final currentMinutes = now.hour * 60 + now.minute;
    final fromMinutes = fromHour * 60 + fromMin;
    final toMinutes = toHour * 60 + toMin;

    if (currentMinutes < fromMinutes || currentMinutes > toMinutes) {
      return ChatAvailability.outsideSchedule;
    }

    return ChatAvailability.available;
  }
}
