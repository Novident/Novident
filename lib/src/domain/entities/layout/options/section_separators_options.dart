import 'dart:convert';

import 'package:novident_remake/src/domain/entities/layout/separators/layout_separator.dart';

class SeparatorOptions {
  final LayoutSeparator separateBeforeSection;
  final LayoutSeparator separatorBetweenSection;
  final LayoutSeparator separatorAfterSection;
  final bool overrideSeparatorAfter;
  final bool ignoreBlankLinesWithStyles;
  SeparatorOptions({
    required this.separateBeforeSection,
    required this.separatorBetweenSection,
    required this.overrideSeparatorAfter,
    required this.ignoreBlankLinesWithStyles,
    required this.separatorAfterSection,
  });

  factory SeparatorOptions.common({
    LayoutSeparator? beforeSection,
    LayoutSeparator? betweenSection,
    LayoutSeparator? afterSection,
  }) {
    return SeparatorOptions(
      separateBeforeSection:
          beforeSection ?? SingleReturnSeparatorStrategy.instance,
      separatorBetweenSection:
          betweenSection ?? SingleReturnSeparatorStrategy.instance,
      separatorAfterSection:
          afterSection ?? SingleReturnSeparatorStrategy.instance,
      overrideSeparatorAfter: true,
      ignoreBlankLinesWithStyles: true,
    );
  }

  SeparatorOptions copyWith({
    LayoutSeparator? separateBeforeSection,
    LayoutSeparator? separatorBetweenSection,
    bool? overrideSeparatorAfter,
    LayoutSeparator? separatorAfterSection,
    bool? ignoreBlankLinesWithStyles,
  }) {
    return SeparatorOptions(
      separateBeforeSection:
          separateBeforeSection ?? this.separateBeforeSection,
      separatorBetweenSection:
          separatorBetweenSection ?? this.separatorBetweenSection,
      overrideSeparatorAfter:
          overrideSeparatorAfter ?? this.overrideSeparatorAfter,
      separatorAfterSection:
          separatorAfterSection ?? this.separatorAfterSection,
      ignoreBlankLinesWithStyles:
          ignoreBlankLinesWithStyles ?? this.ignoreBlankLinesWithStyles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'separateBeforeSection': separateBeforeSection.toJson(),
      'separatorBetweenSection': separatorBetweenSection.toJson(),
      'overrideSeparatorAfter': overrideSeparatorAfter,
      'separatorAfterSection': separatorAfterSection.toJson(),
      'ignoreBlankLinesWithStyles': ignoreBlankLinesWithStyles,
    };
  }

  factory SeparatorOptions.fromMap(Map<String, dynamic> map) {
    return SeparatorOptions(
      separateBeforeSection: LayoutSeparator.fromJson(
        map['separateBeforeSection'] as Map<String, dynamic>,
      )!,
      separatorBetweenSection: LayoutSeparator.fromJson(
        map['separatorBetweenSection'] as Map<String, dynamic>,
      )!,
      overrideSeparatorAfter: map['overrideSeparatorAfter'] as bool,
      separatorAfterSection: LayoutSeparator.fromJson(
        map['separatorAfterSection'] as Map<String, dynamic>,
      )!,
      ignoreBlankLinesWithStyles: map['ignoreBlankLinesWithStyles'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeparatorOptions.fromJson(String source) => SeparatorOptions.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool operator ==(covariant SeparatorOptions other) {
    if (identical(this, other)) return true;

    return other.separateBeforeSection == separateBeforeSection &&
        other.separatorBetweenSection == separatorBetweenSection &&
        other.separatorAfterSection == separatorAfterSection &&
        other.overrideSeparatorAfter == overrideSeparatorAfter &&
        other.ignoreBlankLinesWithStyles == ignoreBlankLinesWithStyles;
  }

  @override
  int get hashCode {
    return separateBeforeSection.hashCode ^
        separatorBetweenSection.hashCode ^
        separatorAfterSection.hashCode ^
        overrideSeparatorAfter.hashCode ^
        ignoreBlankLinesWithStyles.hashCode;
  }
}
