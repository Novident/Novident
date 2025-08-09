import 'dart:convert';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart';
import 'package:novident_remake/src/domain/extensions/delta_extensions.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

enum LetterCase {
  // All string is uppercased
  uppercase,
  // every word will start with uppercased char
  titlecase,
  // All string is lowercased
  lowercase,
  // Maintain the same aspect of the original version
  normal,
}

class TitleOptions {
  //just works with keywords (<$words> or something as <$n> that count the index)
  final String titlePrefix;
  final String titleSuffix;
  final LetterCase lettercasePreffix;
  final LetterCase lettercaseSuffix;
  final LetterCase lettercaseTitle;
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
    required this.lettercaseTitle,
    this.preffix,
    this.suffix,
  });

  factory TitleOptions.common({String? preffix, String? suffix}) {
    return TitleOptions(
      titlePrefix: preffix ?? "",
      titleSuffix: suffix ?? "",
      lettercasePreffix: LetterCase.normal,
      lettercaseSuffix: LetterCase.normal,
      lettercaseTitle: LetterCase.normal,
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
        delta.insert(applyCase(effectiveStr, lettercase: lettercasePreffix),
            inlineAttributes.getNullIfEmpty());
      }
      return delta;
    }
    delta.insert(
      applyCase(titlePrefix, lettercase: lettercasePreffix),
      inlineAttributes,
    );
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
        delta.insert(applyCase(effectiveStr, lettercase: lettercaseSuffix),
            inlineAttributes);
      }
      return delta;
    }
    delta.insert(
        applyCase(titleSuffix, lettercase: lettercaseSuffix), inlineAttributes);
    if (blockAttributes.isNotEmpty) {
      delta.insert('\n', blockAttributes);
    }
    return delta;
  }

  static String applyCase(String str, {required LetterCase lettercase}) {
    switch (lettercase) {
      case LetterCase.titlecase:
        final StringBuffer buffer = StringBuffer();
        bool isStartWithWhitespaces = true;
        bool ignoreUntilNextWhitespace = false;
        for (int i = 0; i < str.length; i++) {
          final bool isWhitespace = str[i].isStrictWhiteSpace;
          if (isStartWithWhitespaces && !isWhitespace) {
            isStartWithWhitespaces = false;
          }

          // Checks if the current character is a whitespace
          if (isWhitespace) {
            buffer.write(str[i]);
            ignoreUntilNextWhitespace = false;
            continue;
          }

          if (ignoreUntilNextWhitespace) {
            buffer.write(str[i]);
            continue;
          }

          // Writes the character
          ignoreUntilNextWhitespace = true;

          buffer.write(str[i].toUpperCase());
        }
        return '$buffer';
      case LetterCase.uppercase:
        return str.toUpperCase();
      case LetterCase.lowercase:
        return str.toLowerCase();
      default:
        return str;
    }
  }

  TitleOptions copyWith({
    String? titlePrefix,
    String? titleSuffix,
    LetterCase? lettercasePreffix,
    LetterCase? lettercaseSuffix,
    LetterCase? lettercaseTitle,
    SectionAttributes? attrPreffix,
    SectionAttributes? attrSuffix,
    String? suffix,
    String? preffix,
  }) {
    return TitleOptions(
      titlePrefix: titlePrefix ?? this.titlePrefix,
      lettercasePreffix: lettercasePreffix ?? this.lettercasePreffix,
      lettercaseSuffix: lettercaseSuffix ?? this.lettercaseSuffix,
      lettercaseTitle: lettercaseTitle ?? this.lettercaseTitle,
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
      'lettercaseTitle': lettercaseTitle.index,
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
      lettercaseTitle: LetterCase.values[map['lettercasePreffix'] as int? ?? 3],
      lettercasePreffix:
          LetterCase.values[map['lettercasePreffix'] as int? ?? 3],
      lettercaseSuffix: LetterCase.values[map['lettercaseSuffix'] as int? ?? 3],
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
        other.lettercaseTitle == lettercaseTitle &&
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
        lettercaseTitle.hashCode ^
        attrPreffix.hashCode ^
        attrSuffix.hashCode ^
        preffix.hashCode ^
        suffix.hashCode;
  }
}
