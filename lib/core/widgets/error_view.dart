import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../errors/app_exception.dart';
import 'lal_state_view.dart';

/// Thin compatibility wrapper around [LALStateView]. Prefer
/// `AsyncErrorView` (auto-classifies any thrown object) in new code.
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final body = exception?.userFriendlyMessage ?? message ?? t.errorGenericBody;
    final isOffline = exception?.kind == LALErrorCode.network;
    return LALStateView(
      kind: isOffline ? LALStateKind.offline : LALStateKind.error,
      title: isOffline ? t.stateOfflineTitle : t.errorGeneric,
      body: body,
      actions: [
        if (onRetry != null)
          LALStateAction(label: t.errorRetry, onTap: onRetry!),
      ],
    );
  }
}
