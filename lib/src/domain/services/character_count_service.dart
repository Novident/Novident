import 'package:flutter_quill/flutter_quill.dart';
import 'package:novident_remake/src/domain/services/editor_service.dart';

class CharacterCountService extends EditorService<Document, int> {
  @override
  bool shouldExecute(Document data) {
    return !data.isEmpty();
  }

  @override
  int execute(Document data) {
    return data.toPlainText().length;
  }
}
