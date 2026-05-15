import 'package:flutter/material.dart';

import 'lal_toast.dart';

/// Compatibility shim — prefer `LALToast.showOffline(context)` in new code.
void showOfflineActionSnackBar(BuildContext context) {
  LALToast.showOffline(context);
}
