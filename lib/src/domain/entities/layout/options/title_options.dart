import 'dart:convert';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart';
import 'package:novident_remake/src/domain/extensions/delta_extensions.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

enum LetterCase { uppercase, lowercase, normal }

class TitleOptions {
  //just works with keywords (<$words> or something as <$n> that count the index)
  final String titlePrefix;
  final String titleSuffix;
  final LetterCase lettercasePreffix;
  final LetterCase lettercaseSuffix;
  //attributes added for each section
  //and doesnt work when titlePrefix and titleSuffix are empty
  final SectionAttributes attrPreffix;
  final SectionAttributes attrSuffix;
  //this will be putted together of the title and it hasnt any attributes
  final String? preffix;
  final String? suffix;
  TitleOptions({
    required this.titlePrefix,
    required this.titleSuffix,
    required this.attrPreffix,
    required this.attrSuffix,
    required this.lettercasePreffix,
    required this.lettercaseSuffix,
    this.preffix,
    this.suffix,
  });

  factory TitleOptions.common({String? preffix, String? suffix}) {
    return TitleOptions(
      titlePrefix: preffix ?? "",
      titleSuffix: suffix ?? "",
      lettercasePreffix: LetterCase.normal,
      lettercaseSuffix: LetterCase.normal,
      attrPreffix: SectionAttributes.common(),
      attrSuffix: SectionAttributes.common(),
    );
  }

  @internal
  Delta buildPrefix() {
    final Delta delta = Delta();
    if (titlePrefix.isEmpty) return delta;
    Map<String, dynamic> blockAttributes =
        attrPreffix.toQuillMap(inline: false);
    Map<String, dynamic> inlineAttributes =
        attrPreffix.toQuillMap(inline: true);
    if (titlePrefix.hasNewLine) {
      final List<String> tokenized = tokenizeWithNewLines(
        titlePrefix,
        newLine: ProjectDefaults.kDefaultLayoutNewlineRepresentation,
      );
      bool isBeginningOfPart = true;
      for (final String str in tokenized) {
        final bool isNewline =
            str == ProjectDefaults.kDefaultLayoutNewlineRepresentation;
        final String effectiveStr = isNewline ? '\n' : str;
        if (!isNewline && isBeginningOfPart) {
          isBeginningOfPart = false;
        }
        if (isNewline) {
          delta.insert(
            effectiveStr,
            isBeginningOfPart ? null : blockAttributes.getNullIfEmpty(),
          );
          continue;
        }
        delta.insert(effectiveStr, inlineAttributes.getNullIfEmpty());
      }
      return delta;
    }
    delta.insert(titlePrefix, inlineAttributes);
    if (blockAttributes.isNotEmpty) {
      delta.insert('\n', blockAttributes);
    }
    return delta;
  }

  @internal
  Delta buildSuffix() {
    final Delta delta = Delta();
    if (titleSuffix.isEmpty) return delta;
    final Map<String, dynamic> blockAttributes =
        attrPreffix.toQuillMap(inline: false);
    final Map<String, dynamic> inlineAttributes =
        attrPreffix.toQuillMap(inline: true);
    if (titleSuffix.hasNewLine) {
      final List<String> tokenized = tokenizeWithNewLines(
        titleSuffix,
        newLine: ProjectDefaults.kDefaultLayoutNewlineRepresentation,
      );
      bool isBeginningOfPart = true;
      for (final String str in tokenized) {
        final bool isNewline =
            str == ProjectDefaults.kDefaultLayoutNewlineRepresentation;
        final String effectiveStr = isNewline ? '\n' : str;
        if (!isNewline && isBeginningOfPart) {
          isBeginningOfPart = false;
        }
        if (isNewline) {
          delta.insert(
              effectiveStr, isBeginningOfPart ? null : blockAttributes);
          continue;
        }
        delta.insert(effectiveStr, inlineAttributes);
      }
      return delta;
    }
    delta.insert(titleSuffix, inlineAttributes);
    if (blockAttributes.isNotEmpty) {
      delta.insert('\n', blockAttributes);
    }
    return delta;
  }

  TitleOptions copyWith({
    String? titlePrefix,
    String? titleSuffix,
    LetterCase? lettercasePreffix,
    LetterCase? lettercaseSuffix,
    SectionAttributes? attrPreffix,
    SectionAttributes? attrSuffix,
    String? suffix,
    String? preffix,
  }) {
    return TitleOptions(
      titlePrefix: titlePrefix ?? this.titlePrefix,
      lettercasePreffix: lettercasePreffix ?? this.lettercasePreffix,
      lettercaseSuffix: lettercaseSuffix ?? this.lettercaseSuffix,
      titleSuffix: titleSuffix ?? this.titleSuffix,
      attrPreffix: attrPreffix ?? this.attrPreffix,
      attrSuffix: attrSuffix ?? this.attrSuffix,
      suffix: suffix ?? this.suffix,
      preffix: preffix ?? this.preffix,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titlePrefix': titlePrefix,
      'titleSuffix': titleSuffix,
      'attrPrefix': attrPreffix.toMap(),
      'attrSuffix': attrSuffix.toMap(),
      'lettercasePreffix': lettercasePreffix.index,
      'lettercaseSuffix': lettercaseSuffix.index,
      'preffix': preffix,
      'suffix': suffix,
    };
  }

  factory TitleOptions.fromMap(Map<String, dynamic> map) {
    return TitleOptions(
      titlePrefix: map['titlePrefix'] as String,
      titleSuffix: map['titleSuffix'] as String,
      lettercasePreffix:
          LetterCase.values[map['lettercasePreffix'] as int? ?? 2],
      lettercaseSuffix: LetterCase.values[map['lettercaseSuffix'] as int? ?? 2],
      suffix: map['suffix'] as String?,
      preffix: map['preffix'] as String?,
      attrPreffix: SectionAttributes.fromMap(
        (map['attrPrefix'] as Map<String, dynamic>),
      ),
      attrSuffix: SectionAttributes.fromMap(
        (map['attrSuffix'] as Map<String, dynamic>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TitleOptions.fromJson(String source) => TitleOptions.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool operator ==(covariant TitleOptions other) {
    if (identical(this, other)) return true;

    return other.titlePrefix == titlePrefix &&
        other.titleSuffix == titleSuffix &&
        other.lettercasePreffix == lettercasePreffix &&
        other.lettercaseSuffix == lettercaseSuffix &&
        other.attrPreffix == attrPreffix &&
        other.attrSuffix == attrSuffix &&
        other.preffix == preffix &&
        other.suffix == suffix;
  }

  @override
  int get hashCode {
    return titlePrefix.hashCode ^
        titleSuffix.hashCode ^
        lettercasePreffix.hashCode ^
        lettercaseSuffix.hashCode ^
        attrPreffix.hashCode ^
        attrSuffix.hashCode ^
        preffix.hashCode ^
        suffix.hashCode;
  }
}
