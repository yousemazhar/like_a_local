import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

void showOfflineActionSnackBar(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(t.offlineActionUnavailable)));
}
