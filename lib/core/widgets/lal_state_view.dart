import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

enum LALStateKind { empty, noResults, offline, error, uploadFailed, notFound }

class LALStateAction {
  const LALStateAction({
    required this.label,
    required this.onTap,
    this.primary = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;
}

/// Unified empty / offline / error / not-found state card.
///
/// Matches the design system mock: white surface card with 18px radius,
/// circular icon badge, Fraunces title, Inter body capped at ~260px wide,
/// and up to two pill action buttons.
class LALStateView extends StatelessWidget {
  const LALStateView({
    super.key,
    required this.kind,
    required this.title,
    required this.body,
    this.icon,
    this.actions = const <LALStateAction>[],
    this.trailing,
    this.compact = false,
  });

  final LALStateKind kind;
  final String title;
  final String body;
  final IconData? icon;
  final List<LALStateAction> actions;

  /// Optional trailing widget (e.g. a chips row for "widen radius").
  final Widget? trailing;

  /// When true, removes outer scroll/padding so the card can be embedded
  /// inside a sliver or list. Defaults to full-screen centered layout.
  final bool compact;

  IconData get _defaultIcon => switch (kind) {
        LALStateKind.empty => Icons.bookmark_border_rounded,
        LALStateKind.noResults => Icons.search_rounded,
        LALStateKind.offline => Icons.wifi_off_rounded,
        LALStateKind.error => Icons.error_outline_rounded,
        LALStateKind.uploadFailed => Icons.cloud_off_rounded,
        LALStateKind.notFound => Icons.help_outline_rounded,
      };

  Color get _iconBg => switch (kind) {
        LALStateKind.empty => LALColors.accentSoft,
        LALStateKind.uploadFailed => LALColors.errorSoft,
        _ => LALColors.surfaceAlt,
      };

  Color get _iconFg => switch (kind) {
        LALStateKind.empty => LALColors.accentDark,
        LALStateKind.uploadFailed => LALColors.errorDark,
        _ => LALColors.c700,
      };

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: LALColors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(color: LALColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: Icon(icon ?? _defaultIcon, color: _iconFg, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: LALTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              body,
              style: LALTypography.bodySmall.copyWith(
                color: LALColors.c500,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(height: 12),
            trailing!,
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: actions.map(_buildAction).toList(growable: false),
            ),
          ],
        ],
      ),
    );

    if (compact) return card;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: LALSpacing.xl,
          vertical: LALSpacing.xxl,
        ),
        child: card,
      ),
    );
  }

  Widget _buildAction(LALStateAction a) {
    final style = a.primary
        ? ElevatedButton.styleFrom(
            backgroundColor: LALColors.c900,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: LALColors.surfaceAlt,
            foregroundColor: LALColors.c800,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );
    return ElevatedButton(
      onPressed: a.onTap,
      style: style,
      child: Text(a.label),
    );
  }
}
