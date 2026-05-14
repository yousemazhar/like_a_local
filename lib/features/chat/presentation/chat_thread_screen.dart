import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../core/widgets/error_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../domain/chat.dart';
import '../domain/chat_providers.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({super.key, required this.threadId});

  final String threadId;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _controller = TextEditingController();
  bool _markedRead = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _maybeMarkRead() {
    if (_markedRead) return;
    _markedRead = true;
    Future.microtask(
      () => ref.read(chatNotifierProvider.notifier).markRead(widget.threadId),
    );
  }

  Future<void> _send(String recipientUid) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (recipientUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat not ready yet — try again.')),
      );
      return;
    }
    _controller.clear();
    try {
      await ref
          .read(chatNotifierProvider.notifier)
          .send(
            threadId: widget.threadId,
            recipientUid: recipientUid,
            text: text,
          );
    } on OfflineException {
      if (!mounted) return;
      _controller.text = text;
      showOfflineActionSnackBar(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not send: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final threadAsync = ref.watch(chatThreadProvider(widget.threadId));
    final messagesAsync = ref.watch(chatMessagesProvider(widget.threadId));
    final user = ref.watch(authStateProvider).valueOrNull;

    final thread = threadAsync.valueOrNull;
    final otherUid =
        thread?.members.firstWhere(
          (m) => m != user?.uid,
          orElse: () => thread.members.isEmpty ? '' : thread.members.first,
        ) ??
        '';
    final otherMeta = thread?.memberMeta[otherUid];
    final otherName = otherMeta?.displayName.isNotEmpty == true
        ? otherMeta!.displayName
        : 'Local';

    if (messagesAsync.hasValue) _maybeMarkRead();

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: LALColors.c100,
              child: Text(
                otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                style: LALTypography.labelMedium.copyWith(
                  color: LALColors.c600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherName, style: LALTypography.labelLarge),
                if (otherMeta?.isSuper ?? false)
                  Text(
                    t.chatSuperLocal,
                    style: LALTypography.bodySmall.copyWith(
                      color: LALColors.accent,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(message: '$e'),
              data: (messages) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (_, i) => _ChatBubble(
                  message: messages[i],
                  isMe: messages[i].senderUid == user?.uid,
                ),
              ),
            ),
          ),
          _Composer(controller: _controller, onSend: () => _send(otherUid)),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.isMe});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? LALColors.c900 : LALColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: LALRadii.lg,
            topRight: LALRadii.lg,
            bottomLeft: isMe ? LALRadii.lg : LALRadii.sm,
            bottomRight: isMe ? LALRadii.sm : LALRadii.lg,
          ),
        ),
        child: Text(
          message.text,
          style: LALTypography.bodyMedium.copyWith(
            color: isMe ? Colors.white : LALColors.c900,
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        border: Border(top: BorderSide(color: LALColors.c100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: t.chatMessageHint,
                filled: true,
                fillColor: LALColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: LALColors.c900,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
