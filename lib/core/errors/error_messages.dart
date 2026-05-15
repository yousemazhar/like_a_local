import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import 'app_exception.dart';
import 'offline_exception.dart';

/// Classify any thrown object into a [LALErrorCode] so the UI can render the
/// right state and copy.
LALErrorCode classifyError(Object error) {
  if (error is AppException) return error.kind;
  if (error is OfflineException) return LALErrorCode.network;
  if (error is SocketException) return LALErrorCode.network;
  if (error is TimeoutException) return LALErrorCode.timeout;
  if (error is FormatException) return LALErrorCode.invalidInput;

  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' =>
        LALErrorCode.invalidInput,
      'email-already-in-use' => LALErrorCode.invalidInput,
      'weak-password' => LALErrorCode.invalidInput,
      'user-disabled' => LALErrorCode.permissionDenied,
      'network-request-failed' => LALErrorCode.network,
      'too-many-requests' => LALErrorCode.quotaExceeded,
      _ => LALErrorCode.unknown,
    };
  }

  if (error is FirebaseFunctionsException) {
    return switch (error.code) {
      'unauthenticated' => LALErrorCode.unauthorized,
      'permission-denied' => LALErrorCode.permissionDenied,
      'not-found' => LALErrorCode.notFound,
      'resource-exhausted' => LALErrorCode.quotaExceeded,
      'invalid-argument' || 'failed-precondition' => LALErrorCode.invalidInput,
      'deadline-exceeded' => LALErrorCode.timeout,
      'unavailable' => LALErrorCode.network,
      _ => LALErrorCode.unknown,
    };
  }

  if (error is FirebaseException) {
    return switch (error.code) {
      'unavailable' || 'network-request-failed' => LALErrorCode.network,
      'permission-denied' => LALErrorCode.permissionDenied,
      'not-found' => LALErrorCode.notFound,
      'unauthenticated' => LALErrorCode.unauthorized,
      'deadline-exceeded' => LALErrorCode.timeout,
      'resource-exhausted' => LALErrorCode.quotaExceeded,
      'invalid-argument' || 'failed-precondition' => LALErrorCode.invalidInput,
      'canceled' => LALErrorCode.unknown,
      _ => LALErrorCode.unknown,
    };
  }

  return LALErrorCode.unknown;
}

/// Localized, user-facing message for any thrown object.
String localizedErrorMessage(BuildContext context, Object error) {
  final t = AppLocalizations.of(context)!;
  // Specialized auth message — keep the existing string when we can identify it.
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return t.authErrorInvalidCredential;
      case 'email-already-in-use':
        return t.authErrorEmailInUse;
      case 'weak-password':
        return t.authErrorWeakPassword;
      case 'invalid-email':
        return t.authErrorInvalidEmail;
      case 'network-request-failed':
        return t.errorNetwork;
    }
  }
  return _messageForKind(t, classifyError(error));
}

String _messageForKind(AppLocalizations t, LALErrorCode kind) => switch (kind) {
      LALErrorCode.network => t.errorNetwork,
      LALErrorCode.timeout => t.errorTimeout,
      LALErrorCode.unauthorized => t.errorUnauthorized,
      LALErrorCode.permissionDenied => t.errorPermissionDenied,
      LALErrorCode.notFound => t.errorNotFound,
      LALErrorCode.quotaExceeded => t.errorQuotaExceeded,
      LALErrorCode.invalidInput => t.errorInvalidInput,
      LALErrorCode.uploadFailed => t.errorUploadFailed,
      LALErrorCode.unknown => t.errorUnknown,
    };
