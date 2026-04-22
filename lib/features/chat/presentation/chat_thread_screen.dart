import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key, required this.threadId});

  final String threadId;

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final _controller = TextEditingController();

  // Placeholder messages
  static const _messages = [
    (text: 'Hey! I saw you saved my place — the tasca in Alfama.', isMe: false),
    (text: 'Yes! Going there on Friday. Any tips?', isMe: true),
    (text: 'Ask for the bacalhau à brás — it\'s not on the menu but they always have it.', isMe: false),
    (text: 'Cash only too. ATM is 50m around the corner.', isMe: false),
    (text: 'Amazing, thank you so much! 🙏', isMe: true),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            const CircleAvatar(
              radius: 18,
              backgroundColor: LALColors.c100,
              child: Icon(Icons.person, color: LALColors.c400, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('João Silva', style: LALTypography.labelLarge),
                Text('Super Local',
                    style: LALTypography.bodySmall
                        .copyWith(color: LALColors.accent, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _ChatBubble(
                text: _messages[i].text,
                isMe: _messages[i].isMe,
              ),
            ),
          ),
          _Composer(controller: _controller, onSend: () {}),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
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
          text,
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
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 10 + MediaQuery.of(context).padding.bottom),
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
                hintText: 'Message…',
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
                    horizontal: 16, vertical: 10),
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
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
