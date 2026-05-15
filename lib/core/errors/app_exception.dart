enum LALErrorCode {
  network,
  unauthorized,
  notFound,
  permissionDenied,
  quotaExceeded,
  invalidInput,
  uploadFailed,
  timeout,
  unknown,
}

class AppException implements Exception {
  const AppException(this.message, {this.code, this.errorCode});

  final String message;
  final String? code;
  final LALErrorCode? errorCode;

  factory AppException.network() => const AppException(
        'No internet connection. Please check your network.',
        code: 'network',
        errorCode: LALErrorCode.network,
      );

  factory AppException.unauthorized() => const AppException(
        'You need to sign in to continue.',
        code: 'unauthorized',
        errorCode: LALErrorCode.unauthorized,
      );

  factory AppException.notFound(String resource) => AppException(
        '$resource not found.',
        code: 'not-found',
        errorCode: LALErrorCode.notFound,
      );

  factory AppException.permissionDenied() => const AppException(
        'You do not have permission to perform this action.',
        code: 'permission-denied',
        errorCode: LALErrorCode.permissionDenied,
      );

  factory AppException.quotaExceeded([String? detail]) => AppException(
        detail ?? 'You have reached the limit for this action.',
        code: 'quota-exceeded',
        errorCode: LALErrorCode.quotaExceeded,
      );

  factory AppException.invalidInput([String? detail]) => AppException(
        detail ?? 'Some of the values you entered are invalid.',
        code: 'invalid-input',
        errorCode: LALErrorCode.invalidInput,
      );

  factory AppException.uploadFailed([String? detail]) => AppException(
        detail ?? 'Upload failed. Please try again.',
        code: 'upload-failed',
        errorCode: LALErrorCode.uploadFailed,
      );

  factory AppException.timeout() => const AppException(
        'The request timed out. Please try again.',
        code: 'timeout',
        errorCode: LALErrorCode.timeout,
      );

  factory AppException.unknown([String? detail]) => AppException(
        detail ?? 'An unexpected error occurred.',
        code: 'unknown',
        errorCode: LALErrorCode.unknown,
      );

  LALErrorCode get kind => errorCode ?? _kindFromCode();

  LALErrorCode _kindFromCode() => switch (code) {
        'network' => LALErrorCode.network,
        'unauthorized' => LALErrorCode.unauthorized,
        'not-found' => LALErrorCode.notFound,
        'permission-denied' => LALErrorCode.permissionDenied,
        'quota-exceeded' => LALErrorCode.quotaExceeded,
        'invalid-input' => LALErrorCode.invalidInput,
        'upload-failed' => LALErrorCode.uploadFailed,
        'timeout' => LALErrorCode.timeout,
        _ => LALErrorCode.unknown,
      };

  String get userFriendlyMessage => switch (kind) {
        LALErrorCode.network => 'No internet.',
        LALErrorCode.unauthorized => 'Please sign in to continue.',
        LALErrorCode.notFound => 'This content is no longer available.',
        LALErrorCode.permissionDenied => 'You don\'t have access to this.',
        LALErrorCode.quotaExceeded => message,
        LALErrorCode.invalidInput => message,
        LALErrorCode.uploadFailed => message,
        LALErrorCode.timeout => 'The request timed out. Please try again.',
        LALErrorCode.unknown => message,
      };

  @override
  String toString() => 'AppException($code): $message';
}
