import 'package:flutter_test/flutter_test.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/services/word_count_service.dart';

void main() {
  final WordCountService service = WordCountService();
  late Document document;

  setUp(() {
    document = Document.empty(details: NodeDetails.base());
  });

  test('should not execute service', () {
    expect(service.shouldExecute(document), isFalse);
    expect(service.execute(document), 0);
  });

  test('should execute service', () {
    document.value.insert('This is an simple example');
    expect(service.shouldExecute(document), isTrue);
    expect(service.execute(document), 5);
  });
}
