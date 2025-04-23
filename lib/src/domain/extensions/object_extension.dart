import 'package:meta/meta.dart';

@internal
extension NullableObject on Object? {
  bool get isNull => this == null;
}
