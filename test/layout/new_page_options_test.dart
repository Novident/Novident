import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/layout/options/new_page_options.dart';

void main() {
  group('New lines generator option', () {
    final List<Operation> basicDeltaWithTwoInserts = [
      Operation.insert('test '),
      Operation.insert('Content'),
    ];
    test('Should Should add new lines at the start in the delta by index', () {
      final NewPageOptions newPageOptions =
          NewPageOptions(newLinesCount: 2, charactersToUpperCase: 0);
      final List<Operation> newLines = newPageOptions.getNewLines();
      expect(newLines, isNotEmpty);
      expect([
        ...newLines,
        ...basicDeltaWithTwoInserts,
      ], [
        Operation.insert('\n'),
        Operation.insert('\n'),
        ...basicDeltaWithTwoInserts,
      ]);
    });
  });

  group('Uppercase option', () {
    test('Should add new lines at the start with uppercased index ', () {
      final expected = [
        Operation.insert('\n\nTEST content'),
      ];
      final NewPageOptions newPageOptions = NewPageOptions(
        newLinesCount: 2,
        charactersToUpperCase: 4,
      );
      final List<Operation> newLines = newPageOptions.getNewLines();
      final Delta delta = Delta.fromOperations([
        ...newLines,
        Operation.insert('test '),
        Operation.insert('content'),
      ]);
      final Delta? newDelta = newPageOptions.toUpperCase(delta: delta);
      expect(newLines, isNotNull);
      expect(newDelta?.operations, isNotEmpty);
      expect(newDelta?.operations, expected);
    });

    test('Should capitalize the delta by index', () {
      final Delta expected = Delta()..insert('TEST content');
      final NewPageOptions newPageOptions =
          NewPageOptions(newLinesCount: 0, charactersToUpperCase: 4);
      final Delta? newDelta =
          newPageOptions.toUpperCase(delta: Delta()..insert('test content'));
      expect(newDelta, isNotNull);
      expect(newDelta, expected);
    });

    test('Should capitalize a more complex delta by index', () {
      final Delta deltaWithAttr = Delta.fromOperations([
        Operation.insert('test ', {'size': 12}),
        Operation.insert('content'),
      ]);

      final List<Operation> expected = [
        Operation.insert('TEST ', {'size': 12}),
        Operation.insert('CONtent'),
      ];

      final NewPageOptions newPageOptions =
          NewPageOptions(newLinesCount: 0, charactersToUpperCase: 8);
      final Delta? newDelta = newPageOptions.toUpperCase(delta: deltaWithAttr);
      expect(newDelta, isNotNull);
      expect(newDelta?.operations, expected);
    });

    test('Should capitalize a plain content by index', () {
      final Delta plainText = Delta()..insert('test content\n');
      final Delta expected = Delta()..insert('TEST CONTent\n');
      final NewPageOptions newPageOptions =
          NewPageOptions(newLinesCount: 0, charactersToUpperCase: 9);
      final Delta? plainTextCapitalized =
          newPageOptions.toUpperCase(delta: plainText);
      expect(plainTextCapitalized, isNotNull);
      expect(plainTextCapitalized, expected);
    });

    test(
        'Should capitalize a more complex delta by index that contains new lines',
        () {
      final List<Operation> operationsWithNewLines = [
        Operation.insert('\ntest ', {'size': 12}),
        Operation.insert('\n\n\n\n'),
        Operation.insert(' content'),
        Operation.insert('\n', {'header': 2}),
      ];
      final List<Operation> expected = [
        Operation.insert('\n'),
        Operation.insert('\nTEST ', {'size': 12}),
        Operation.insert('\n\n\n\n CONtent'),
        Operation.insert('\n', {'header': 2}),
      ];
      final NewPageOptions newPageOptions =
          NewPageOptions(newLinesCount: 1, charactersToUpperCase: 9);
      final List<Operation> newLines = newPageOptions.getNewLines();
      final Delta? newDelta = newPageOptions.toUpperCase(
        delta: Delta.fromOperations(
          [
            ...newLines,
            ...operationsWithNewLines,
          ],
        ),
      );
      expect(newDelta, isNotNull);
      expect(newDelta?.operations, isNotEmpty);
      expect(newDelta?.operations, expected);
    });
  });
}
