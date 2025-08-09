class IllegalOperationException implements Exception {
  final Object object;
  final String description;

  IllegalOperationException({required this.object, required this.description});

  @override
  String toString() {
    return 'IllegalOperationException: $object was removed illegaly, when $description';
  }
}
