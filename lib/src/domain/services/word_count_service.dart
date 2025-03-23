import 'package:flutter_quill/flutter_quill.dart';
import 'package:novident_remake/src/domain/services/editor_service.dart';

class WordCountService extends EditorService<Document, int> {
  static final RegExp _wordCountPattern = RegExp(r'\S+');

  @override
  bool shouldExecute(Document data) {
    return !data.isEmpty();
  }

  @override
  int execute(Document data) {
    final String plainText = data.toPlainText();
    final int count = _wordCountPattern.allMatches(plainText).length;
    return count;
  }
}
