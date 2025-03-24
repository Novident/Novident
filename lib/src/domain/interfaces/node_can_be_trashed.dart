import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';

/// [NodeHasName] represents a [Node] that could be into the trash folder
///
/// This is useful when we need to know what will be removed and ignored
mixin NodeCanBeTrashed {
  NodeTrashedOptions get trashStatus;
  Node setTrashState();
}
