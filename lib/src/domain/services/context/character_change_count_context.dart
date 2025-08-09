import 'package:novident_nodes/novident_nodes.dart';

/// Determines the change applied to the node
/// that should be registered
class CharacterChangeCountContext {
  final Node node;
  final int lengthOfChange;
  final String changeType;

  static const String deleteChangeKey = 'delete';
  static const String insertChangeKey = 'insert';

  const CharacterChangeCountContext({
    required this.node,
    required this.lengthOfChange,
    required this.changeType,
  });

  const CharacterChangeCountContext.insert({
    required this.node,
    required this.lengthOfChange,
  }) : changeType = insertChangeKey;

  const CharacterChangeCountContext.delete({
    required this.node,
    required this.lengthOfChange,
  }) : changeType = deleteChangeKey;

  bool get isValid => lengthOfChange >= 1 && hasValidChange;
  bool get hasValidChange => isInsert || isDelete;

  bool get isDelete => changeType == deleteChangeKey;
  bool get isInsert => changeType == insertChangeKey;
}
