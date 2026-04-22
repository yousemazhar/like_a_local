class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  factory AppException.network() => const AppException(
        'No internet connection. Please check your network.',
        code: 'network',
      );

  factory AppException.unauthorized() => const AppException(
        'You need to sign in to continue.',
        code: 'unauthorized',
      );

  factory AppException.notFound(String resource) => AppException(
        '$resource not found.',
        code: 'not-found',
      );

  factory AppException.permissionDenied() => const AppException(
        'You do not have permission to perform this action.',
        code: 'permission-denied',
      );

  factory AppException.unknown([String? detail]) => AppException(
        detail ?? 'An unexpected error occurred.',
        code: 'unknown',
      );

  String get userFriendlyMessage => switch (code) {
        'network' => 'No internet connection.',
        'unauthorized' => 'Please sign in to continue.',
        'not-found' => 'This content is no longer available.',
        'permission-denied' => 'You don\'t have access to this.',
        _ => message,
      };

  @override
  String toString() => 'AppException($code): $message';
}
