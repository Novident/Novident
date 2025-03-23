import 'package:novident_remake/src/domain/entities/node/node.dart';

typedef Predicate = bool Function(Node node);
typedef ConditionalPredicate<T> = bool Function(T data);

mixin NodeVisitor {
  Node? visitNode({required Predicate shouldGetNode});
  Node? visitAllNodes({required Predicate shouldGetNode});
  bool exist(String id);
  bool deepExist(String id);
}
