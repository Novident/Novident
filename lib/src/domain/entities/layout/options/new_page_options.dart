import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/object_value.dart';
import 'package:novident_remake/src/domain/extensions/delta_extensions.dart';

@immutable
class NewPageOptions extends Equatable {
  /// based on the count of the value passed
  ///
  /// will create the new lines
  final ObjectValue<int> newLinesCount;

  /// Transform every character into the range passed to be uppercased
  ///
  /// Example:
  /// ```dart
  /// NewPageOptions(
  ///   newLinesCount: 0,
  ///   charactersToUpperCase: 2,
  /// );
  /// ```
  ///
  /// If you have a document with the content:
  ///
  /// ```console
  /// "first word"
  /// ```
  ///
  /// The compiler will take this option, and will apply the value passed
  /// and transform your text to be something like:
  ///
  /// ```console
  /// "FIrst words"
  /// ```
  ///
  /// You need to take in account that this value is just used after a page break
  final ObjectValue<int> charactersToUpperCase;
  NewPageOptions({
    required int newLinesCount,
    required int charactersToUpperCase,
  })  : newLinesCount = ObjectValue(value: newLinesCount),
        charactersToUpperCase = ObjectValue(value: charactersToUpperCase),
        assert(
          charactersToUpperCase <= 10 && charactersToUpperCase >= 0,
          'IndexForConvertingToUpperCase only can be less or equals than teen or mayor or equals than zero',
        ),
        assert(
          newLinesCount >= 0,
          'newLinesCount must be major or equals than zero',
        );

  factory NewPageOptions.common() {
    return NewPageOptions(
      newLinesCount: 0,
      charactersToUpperCase: 0,
    );
  }

  List<Operation> getNewLines({
    String? customNewLine,
    int? newLines,
    bool addCommaAfterNewLine = false,
  }) {
    final comma = _getCommaIfNeeded(addCommaAfterNewLine);
    final Operation toCopy = Operation.insert('$comma${customNewLine ?? '\n'}$comma');
    if ((newLines == null || newLines < 1) && newLinesCount.value < 1) {
      return <Operation>[];
    }
    return newLines != null
        ? List<Operation>.filled(newLines, toCopy)
        : List<Operation>.filled(newLinesCount.value, toCopy);
  }

  Delta? toUpperCase({required Delta delta}) {
    if (charactersToUpperCase.value < 1) return delta;
    return delta.toUppercase(charactersToUpperCase.value);
  }

  String _getCommaIfNeeded(bool addCommaAfterNewLine) {
    return addCommaAfterNewLine ? ',' : '';
  }

  @override
  List<Object?> get props => [
        newLinesCount,
        charactersToUpperCase,
      ];

  NewPageOptions copyWith({
    int? newLinesCount,
    int? charactersToUpperCase,
  }) {
    return NewPageOptions(
      newLinesCount: newLinesCount ?? this.newLinesCount.value,
      charactersToUpperCase: charactersToUpperCase ?? this.charactersToUpperCase.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newLinesCount': newLinesCount.value,
      'charactersToUpperCase': charactersToUpperCase.value,
    };
  }

  factory NewPageOptions.fromMap(Map<String, dynamic> map) {
    return NewPageOptions(
      newLinesCount: map['newLinesCount'] as int,
      charactersToUpperCase: map['charactersToUpperCase'] as int,
    );
  }

  void increaseNewLines() {
    newLinesCount.value++;
  }

  void decreaseNewLines() {
    if (charactersToUpperCase.value > 0) {
      charactersToUpperCase.value--;
    }
  }

  void increaseToUppercaseIndexing() {
    if (charactersToUpperCase.value < 10) {
      charactersToUpperCase.value++;
    }
  }

  void decreaseToUppercaseIndexing() {
    if (charactersToUpperCase.value > 0) {
      charactersToUpperCase.value--;
    }
  }

  @override
  String toString() => 'NewPageOptions('
      'newLinesCount: $newLinesCount, '
      'charactersToUpperCase: $charactersToUpperCase'
      ')';

  String toJson() => json.encode(toMap());

  factory NewPageOptions.fromJson(String source) =>
      NewPageOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
