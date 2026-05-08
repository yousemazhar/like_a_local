import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final _messages = <({String text, bool isMe})>[];
  bool _initialized = false;
  bool _typing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final t = AppLocalizations.of(context)!;
      _messages.add((text: t.aiGreeting, isMe: false));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final suggestions = [
      t.aiSuggestion1,
      t.aiSuggestion2,
      t.aiSuggestion3,
      t.aiSuggestion4,
    ];

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
                Text(t.aiTitle, style: LALTypography.labelLarge),
                Text(t.aiPoweredBy,
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
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _send(suggestions[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: LALColors.surface,
                      borderRadius: LALRadii.pillBorder,
                      border: Border.all(color: LALColors.c200),
                    ),
                    child: Text(suggestions[i],
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
                      hintText: t.aiPlaceholder,
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
    final t = AppLocalizations.of(context)!;
    _controller.clear();
    setState(() {
      _messages.add((text: trimmed, isMe: true));
      _typing = true;
    });
    final reply = await _composeReply(trimmed, t);
    if (mounted) {
      setState(() {
        _typing = false;
        _messages.add((text: reply, isMe: false));
      });
    }
  }

  Future<String> _composeReply(String query, AppLocalizations t) async {
    try {
      final repo = ref.read(placeRepositoryProvider);
      final all = await repo.discoverFeed(limit: 60).first;
      final lower = query.toLowerCase();
      bool matches(Place p) =>
          p.title.toLowerCase().contains(lower) ||
          p.neighborhood.toLowerCase().contains(lower) ||
          p.city.toLowerCase().contains(lower) ||
          p.category.toLowerCase().contains(lower) ||
          p.moods.any((m) => m.toLowerCase().contains(lower));
      var hits = all.where(matches).toList(growable: false);
      if (hits.isEmpty) {
        // fall back to top-rated picks if nothing matched the keywords.
        final sorted = [...all]
          ..sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
        hits = sorted.take(3).toList();
      } else if (hits.length > 5) {
        hits = hits.take(5).toList();
      }
      if (hits.isEmpty) return t.aiFallbackReply;
      final lines = hits.map((p) {
        final loc = [p.neighborhood, p.city]
            .where((s) => s.isNotEmpty)
            .join(', ');
        final rating = p.ratingCount > 0
            ? ' · ★ ${p.ratingAvg.toStringAsFixed(1)}'
            : '';
        return '• ${p.title}${loc.isNotEmpty ? ' — $loc' : ''}$rating';
      }).join('\n');
      return '${_lead(query)}\n$lines';
    } catch (_) {
      return t.aiFallbackReply;
    }
  }

  String _lead(String query) {
    final lower = query.toLowerCase();
    if (lower.contains('coffee') || lower.contains('cafe')) {
      return 'Here are some cafés locals love:';
    }
    if (lower.contains('eat') ||
        lower.contains('food') ||
        lower.contains('restaurant')) {
      return 'A few favourite places to eat:';
    }
    if (lower.contains('view') || lower.contains('sunset')) {
      return 'Try these viewpoints:';
    }
    return 'You might like these:';
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
