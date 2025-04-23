import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/layout/separators/layout_separator.dart';
import 'package:novident_remake/src/domain/exceptions/unknown_layout_separator_exception.dart';

void main() {
  // common
  test('should return a CustomSeparatorStrategy', () {
    expect(
      LayoutSeparator.fromJson(CustomSeparatorStrategy.internal().toJson()),
      CustomSeparatorStrategy.internal(),
    );
  });
  test('should return a PageBreakSeparatorStrategy', () {
    expect(
      LayoutSeparator.fromJson(PageBreakSeparatorStrategy.instance.toJson()),
      PageBreakSeparatorStrategy.instance,
    );
  });
  test('should return a EmptyLineSeparatorStrategy', () {
    expect(
      LayoutSeparator.fromJson(EmptyLineSeparatorStrategy.instance.toJson()),
      EmptyLineSeparatorStrategy.instance,
    );
  });
  test('should return a SingleReturnSeparatorStrategy', () {
    expect(
      LayoutSeparator.fromJson(SingleReturnSeparatorStrategy.instance.toJson()),
      SingleReturnSeparatorStrategy.instance,
    );
  });

  // exceptions
  test('should throw an exceptions by unknown id', () {
    expect(
      () =>
          LayoutSeparator.fromJson({LayoutSeparator.separatorIdKey: 'unknown'}),
      throwsA(
        isA<UnknownLayoutSeparatorException>(),
      ),
    );
  });
  test('should throw an exceptions by empty json', () {
    expect(
      () => LayoutSeparator.fromJson(<String, dynamic>{}),
      throwsA(
        isA<UnknownLayoutSeparatorException>(),
      ),
    );
  });
}
