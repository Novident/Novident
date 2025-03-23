class BadProjectStateException implements Exception {
  final String reason;

  BadProjectStateException({
    required this.reason,
  });

  @override
  String toString() {
    return reason;
  }
}
