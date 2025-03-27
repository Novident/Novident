class DisposedCacheException implements Exception {
  final String fromCache;

  DisposedCacheException({
    required this.fromCache,
  });

  @override
  String toString() {
    return 'DisposedCacheException: was detected a call for notify listeners, but $fromCache is already disposed.';
  }
}
