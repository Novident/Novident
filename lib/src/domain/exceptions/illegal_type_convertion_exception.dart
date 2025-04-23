class IllegalTypeConvertionException implements Exception {
  final List<Type> type;
  final Type? founded;

  IllegalTypeConvertionException({required this.type, required this.founded});

  @override
  String toString() {
    return 'IllegalTypeConvertionException: the object of type $type was expected, but founded $founded';
  }
}
