import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/services/character_count_service.dart';

void main() {
  final CharacterCountService service = CharacterCountService();
  late Document document;

  setUp(() {
    document = Document();
  });

  test('should not execute service', () {
    expect(service.shouldExecute(document), isFalse);
    expect(service.execute(document), 0);
  });

  test('should not execute service', () {
    document.insert(0, 'This is an simple example');
    expect(service.shouldExecute(document), isTrue);
    expect(service.execute(document), 25);
  });
}
