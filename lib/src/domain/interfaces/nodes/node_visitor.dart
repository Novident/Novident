import 'package:novident_remake/src/domain/entities/node/node.dart';

typedef Predicate = bool Function(Node node);
typedef ConditionalPredicate<T> = bool Function(T data);

/// This is a base class that contains the necessary method for
/// gettings nodes and search them
mixin NodeVisitor {
  /// Visit the node at the root of the Nodes container
  /// and checks if we should return it
  Node? visitNode({required Predicate shouldGetNode});

  /// Visit the all the nodes into the Node, and, if not found it
  /// in the root, search into its child-children to get the exact Node
  Node? visitAllNodes({required Predicate shouldGetNode});

  /// Count the nodes that satifies the predicate
  int countNodes({required Predicate countNode});

  /// Count all the nodes that satifies the predicate
  /// searching too into its child-children
  int countAllNodes({required Predicate countNode});
  bool exist(String id);
  bool deepExist(String id);
}
