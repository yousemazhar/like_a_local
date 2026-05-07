import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/review.dart';
import '../domain/review_providers.dart';

class ReviewComposerSheet extends ConsumerStatefulWidget {
  const ReviewComposerSheet({
    super.key,
    required this.placeId,
    this.existing,
  });

  final String placeId;
  final Review? existing;

  static Future<void> show(
    BuildContext context, {
    required String placeId,
    Review? existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewComposerSheet(placeId: placeId, existing: existing),
    );
  }

  @override
  ConsumerState<ReviewComposerSheet> createState() =>
      _ReviewComposerSheetState();
}

class _ReviewComposerSheetState extends ConsumerState<ReviewComposerSheet> {
  late final TextEditingController _controller;
  late int _rating;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _controller = TextEditingController(text: widget.existing?.text ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(reviewNotifierProvider.notifier).submit(
            placeId: widget.placeId,
            rating: _rating,
            text: text,
          );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        decoration: const BoxDecoration(
          color: LALColors.surface,
          borderRadius: BorderRadius.vertical(top: LALRadii.xl),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: LALColors.c200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(t.reviewComposerTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(t.reviewComposerBody, style: LALTypography.bodySmall),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () => setState(() => _rating = i),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        i <= _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: LALColors.accent,
                        size: 36,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: t.reviewComposerHint,
                filled: true,
                fillColor: LALColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: LALRadii.lgBorder,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(widget.existing == null
                        ? t.reviewComposerSubmit
                        : t.reviewComposerUpdate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
