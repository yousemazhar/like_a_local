import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/auth_providers.dart';
import '../data/chat_repository.dart';
import 'chat.dart';

part 'chat_providers.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) =>
    ChatRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<ChatThread>> myThreads(MyThreadsRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(chatRepositoryProvider).threadsForUser(user.uid);
}

@riverpod
Stream<ChatThread?> chatThread(ChatThreadRef ref, String threadId) =>
    ref.watch(chatRepositoryProvider).thread(threadId);

@riverpod
Stream<List<ChatMessage>> chatMessages(
    ChatMessagesRef ref, String threadId) =>
    ref.watch(chatRepositoryProvider).messages(threadId);

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  void build() {}

  Future<String?> openWithUser({
    required String otherUid,
    required String otherDisplayName,
    String? otherPhotoUrl,
    bool otherIsSuper = false,
    String? placeContext,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return null;
    return ref.read(chatRepositoryProvider).ensureThread(
          currentUid: user.uid,
          currentDisplayName: user.displayName ?? user.email,
          currentPhotoUrl: user.photoUrl,
          otherUid: otherUid,
          otherDisplayName: otherDisplayName,
          otherPhotoUrl: otherPhotoUrl,
          otherIsSuper: otherIsSuper,
          placeContext: placeContext,
        );
  }

  Future<void> send({
    required String threadId,
    required String recipientUid,
    required String text,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null || text.trim().isEmpty || recipientUid.isEmpty) return;
    await ref.read(chatRepositoryProvider).sendMessage(
          threadId: threadId,
          senderUid: user.uid,
          recipientUid: recipientUid,
          text: text.trim(),
        );
  }

  Future<void> markRead(String threadId) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref.read(chatRepositoryProvider).markRead(threadId, user.uid);
  }
}
