import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/services/editor_service.dart';

import '../interfaces/interfaces.dart';

class WordCountService extends EditorService<Node, int> {
  static final RegExp _wordCountPattern = RegExp(r'\S+');

  @override
  bool shouldExecute(Node data) {
    if (data is! NodeHasValue<Delta>) {
      return false;
    }
    return data.cast<NodeHasValue<Delta>>().value.isNotEmpty;
  }

  @override
  void onLoadNewData(Object? oldState, Object newState) {}

  @override
  int execute(Node data) {
    if (data is NodeHasValue<Delta>) {
      final String plainText = data.cast<NodeHasValue<Delta>>().value.toPlain();
      if (plainText == '\n') return 0;
      final int count = _wordCountPattern.allMatches(plainText).length;
      return count;
    }
    return -1;
  }
}
