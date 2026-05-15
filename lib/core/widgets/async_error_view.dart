import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../errors/app_exception.dart';
import '../errors/error_messages.dart';
import 'lal_state_view.dart';

/// Render any thrown object as a [LALStateView] with the right kind/copy
/// derived from [classifyError] + [localizedErrorMessage]. Use as the
/// `error:` branch of an `AsyncValue.when`.
class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final kind = classifyError(error);
    final body = localizedErrorMessage(context, error);
    final stateKind = switch (kind) {
      LALErrorCode.network => LALStateKind.offline,
      LALErrorCode.notFound => LALStateKind.notFound,
      LALErrorCode.uploadFailed => LALStateKind.uploadFailed,
      _ => LALStateKind.error,
    };
    final title = switch (stateKind) {
      LALStateKind.offline => t.stateOfflineTitle,
      LALStateKind.notFound => t.stateNotFoundTitle,
      LALStateKind.uploadFailed => t.stateUploadFailedTitle,
      _ => t.errorGeneric,
    };
    return LALStateView(
      kind: stateKind,
      title: title,
      body: body,
      compact: compact,
      actions: [
        if (onRetry != null)
          LALStateAction(label: t.actionRetry, onTap: onRetry!),
      ],
    );
  }
}
