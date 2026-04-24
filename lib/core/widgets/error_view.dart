import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import '../errors/app_exception.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.exception,
    this.message,
    this.onRetry,
  });

  final AppException? exception;
  final String? message;
  final VoidCallback? onRetry;

  String _displayMessage(BuildContext context) =>
      exception?.userFriendlyMessage ??
      message ??
      AppLocalizations.of(context)!.errorGenericBody;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: LALColors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: LALColors.c400,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t.errorGeneric,
              style: LALTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _displayMessage(context),
              style: LALTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(t.errorRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
