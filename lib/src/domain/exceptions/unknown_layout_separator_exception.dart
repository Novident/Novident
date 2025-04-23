class UnknownLayoutSeparatorException implements Exception {
  final String id;

  UnknownLayoutSeparatorException({
    required this.id,
  });

  @override
  String toString() {
    return 'UnknownLayoutSeparatorException: '
        'the id "$id" does not correspond '
        'with any of the existent '
        'separator implementations.';
  }
}
