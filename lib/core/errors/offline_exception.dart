class OfflineException implements Exception {
  const OfflineException();

  @override
  String toString() => 'This action cannot be done offline.';
}
