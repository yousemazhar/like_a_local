import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../errors/error_messages.dart';

enum LALToastKind { info, success, warning, error }

/// Lightweight, design-system-aligned snackbar.
///
/// Use for transient feedback (saved, action failed, offline mutation, etc.).
/// For full-screen empty/error/offline states use `LALStateView` instead.
class LALToast {
  LALToast._();

  static void show(
    BuildContext context,
    String message, {
    LALToastKind kind = LALToastKind.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final hasAction = actionLabel != null && onAction != null;
    final bg = _bg(kind);
    final fg = _fg(kind);

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        elevation: 2,
        duration: duration ??
            (hasAction ? const Duration(seconds: 5) : const Duration(seconds: 3)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        content: Row(
          children: [
            Icon(_icon(kind), color: fg, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: hasAction
            ? SnackBarAction(
                label: actionLabel,
                textColor: fg,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Convenience: surface any thrown object as an error toast with localized copy.
  static void showError(BuildContext context, Object error,
      {String? actionLabel, VoidCallback? onAction}) {
    show(
      context,
      localizedErrorMessage(context, error),
      kind: LALToastKind.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Convenience: localized "this action can't be done offline" toast.
  static void showOffline(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    show(context, t.offlineActionUnavailable, kind: LALToastKind.warning);
  }

  static Color _bg(LALToastKind kind) => switch (kind) {
        LALToastKind.success => LALColors.success,
        LALToastKind.warning => LALColors.warning,
        LALToastKind.error => LALColors.error,
        LALToastKind.info => LALColors.c800,
      };

  static Color _fg(LALToastKind kind) => switch (kind) {
        LALToastKind.warning => LALColors.c900,
        _ => Colors.white,
      };

  static IconData _icon(LALToastKind kind) => switch (kind) {
        LALToastKind.success => Icons.check_circle_rounded,
        LALToastKind.warning => Icons.wifi_off_rounded,
        LALToastKind.error => Icons.error_outline_rounded,
        LALToastKind.info => Icons.info_outline_rounded,
      };
}
