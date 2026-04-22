import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _suggestions = [
    'Where to eat solo tonight?',
    'Best Sunday brunch spots',
    'Hidden bars in Bairro Alto',
    'Viewpoints without the crowds',
  ];

  final _messages = <({String text, bool isMe})>[
    (
      text:
          'Hi! I\'m your Local AI. I know Lisbon\'s hidden gems inside out. What are you looking for today?',
      isMe: false,
    ),
  ];

  bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: LALColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Local AI', style: LALTypography.labelLarge),
                Text('Powered by Gemini',
                    style: LALTypography.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (_typing && i == _messages.length) {
                  return const _TypingIndicator();
                }
                final m = _messages[i];
                return _AiBubble(text: m.text, isMe: m.isMe);
              },
            ),
          ),
          // Suggestion chips (only at start)
          if (_messages.length == 1)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _send(_suggestions[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: LALColors.surface,
                      borderRadius: LALRadii.pillBorder,
                      border: Border.all(color: LALColors.c200),
                    ),
                    child: Text(_suggestions[i],
                        style: LALTypography.labelMedium),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Composer
          Container(
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask about the best places…',
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
                    onSubmitted: _send,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _send(_controller.text),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: LALColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.add((text: trimmed, isMe: true));
      _typing = true;
    });
    // TODO: Call Cloud Function `aiChat` callable
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    if (mounted) {
      setState(() {
        _typing = false;
        _messages.add((
          text:
              'Great question! Based on your preferences, I recommend checking out the Alfama area. There are some hidden gems that locals love. Would you like me to narrow down by cuisine or atmosphere?',
          isMe: false,
        ));
      });
    }
  }
}

class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
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

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.lgBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: LALColors.c400,
                  shape: BoxShape.circle,
                ),
              ),
              if (i < 2) const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }
}
