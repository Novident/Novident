import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';

@internal
abstract class NodeChange {
  NodeChange({
    required this.newState,
    this.oldState,
  });

  final Node? oldState;
  final Node newState;
}

@internal
class NodeInsertion extends NodeChange {
  final Node to;

  /// if it is null, means that the node
  /// was created
  final Node? from;
  NodeInsertion({
    required this.to,
    required this.from,
    required super.newState,
    super.oldState,
  });
}

@internal
class NodeMoveChange extends NodeChange {
  final Node to;

  /// if it is null, means that the node
  /// was created
  final Node? from;
  NodeMoveChange({
    required this.to,
    required this.from,
    required super.newState,
    super.oldState,
  });
}

@internal
class NodeUpdate extends NodeChange {
  NodeUpdate({
    required super.newState,
    super.oldState,
  });
}

@internal
class NodeDeletion extends NodeChange {
  final int originalPosition;
  // this is the parent that is more near
  // of the root
  final Node sourceOwner;
  final Node inNode;
  NodeDeletion({
    required this.originalPosition,
    required this.inNode,
    required this.sourceOwner,
    required super.newState,
    super.oldState,
  });
}
