import 'dart:collection';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/extensions.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';
import 'package:novident_remake/src/domain/interfaces/interfaces.dart';
import 'context/character_change_count_context.dart';
import 'editor_service.dart';

class CharacterCountService extends EditorService<Node, int> {
  /// Cache of the documents that were counted already
  final HashMap<String, int> _cachedCount = HashMap<String, int>();
  bool _preventExecution = false;

  HashMap<String, int> get countHistory =>
      HashMap<String, int>.from(_cachedCount);

  @override
  bool shouldExecute(Node data) {
    if (data is! NodeHasValue<Delta>) {
      return false;
    }
    return data.cast<NodeHasValue<Delta>>().value.isNotEmpty;
  }

  @override
  void onLoadNewData(Object? oldState, Object newState) {
    assert(oldState == null || oldState is CharacterChangeCountContext,
        'oldState must be a Delta object. Received: $oldState');
    assert(newState is CharacterChangeCountContext,
        'newState must be a Map object. Received: $newState');

    if (oldState != null &&
        newState.cast<CharacterChangeCountContext>().isValid) {
      final CharacterChangeCountContext oldChange =
          oldState.cast<CharacterChangeCountContext>();
      final CharacterChangeCountContext newChange =
          newState.cast<CharacterChangeCountContext>();
      if (_cachedCount[oldChange.node.id] != null &&
          oldChange.node.id.equals(newChange.node.id)) {
        final int oldLength = _cachedCount[oldChange.node.id]!;
        if (newChange.isInsert) {
          _cachedCount[oldChange.node.id] =
              newChange.lengthOfChange + oldLength;
        }
        if (newChange.isDelete) {
          _cachedCount[oldChange.node.id] =
              oldLength - newChange.lengthOfChange;
        }
        _preventExecution = true;
      }
    }
  }

  @override
  int execute(Node data) {
    if (_preventExecution && _cachedCount[data.id] != null) {
      _preventExecution = false;
      return _cachedCount[data.id]!;
    }
    _preventExecution = false;
    if (data is NodeHasValue<Delta>) {
      return data
          .cast<NodeHasValue<Delta>>()
          .value
          .toPlain()
          .removeNewLines
          .length;
    }
    return -1;
  }
}
