import 'package:meta/meta.dart';

mixin ClonableMixin<T> {
  @mustBeOverridden
  T clone(); 
}
