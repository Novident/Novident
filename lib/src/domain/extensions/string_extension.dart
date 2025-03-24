import 'package:novident_remake/src/domain/project_defaults.dart';

extension UppercaseCaseStringExtension on String {
  String capitalize() {
    return isEmpty || length < 2
        ? this
        : "${this[0].toUpperCase()}${substring(1)}";
  }

  (String, int) capitalizeByIndex({int? startIndex, required int endIndex}) {
    final StringBuffer buffer = StringBuffer();
    int lastIndex = 0;
    int end = endIndex;
    for (int i = 0; i < endIndex; i++) {
      if (i >= length) break;
      if ((startIndex != null && i < startIndex) || this[i] == '\n') {
        buffer.write(this[i]);
        continue;
      }
      buffer.write(this[i].toUpperCase());
      lastIndex = i + 1;
      end--;
    }
    return ('${buffer..write(substring(lastIndex))}', end);
  }
}

extension ShortStringExtension on String {
  String shortString() {
    return length > 6 ? substring(0, 6) : this;
  }

  bool equals(
    String other, {
    bool caseSensitive = true,
    Pattern? pattern,
    bool useThisInstead = false,
  }) {
    if (!caseSensitive) return toLowerCase() == other.toLowerCase();
    return pattern != null
        ? pattern is RegExp
            ? pattern.hasMatch(useThisInstead ? this : other)
            : pattern.allMatches(useThisInstead ? this : other).isNotEmpty
        : this == other;
  }

  String replaceDefaultNewLine({
    bool caseSensitive = false,
    String defaultReplace = '\n',
  }) =>
      replaceAll(
        RegExp(
          ProjectDefaults.kDefaultLayoutNewlineRepresentation,
          caseSensitive: caseSensitive,
        ),
        defaultReplace,
      );

  String get removeNewLines => replaceAll(
        RegExp(r'\n+'),
        '',
      );

  String replaceNewLine({
    bool asDelta = true,
    bool caseSensitive = false,
    String defaultReplace = '\n',
  }) =>
      replaceAll(
        RegExp(r'(\n)+', caseSensitive: caseSensitive),
        asDelta ? r'{"insert": "\n"}' : defaultReplace,
      );
}

extension LayoutNewLinesExtension on String {
  bool get hasNewLine {
    return RegExp('${ProjectDefaults.kDefaultLayoutNewlineRepresentation}+')
        .hasMatch(this);
  }

  bool get hasNewLineAtEnd {
    return endsWith(ProjectDefaults.kDefaultLayoutNewlineRepresentation);
  }

  bool get hasNewLineAtStart {
    return startsWith(ProjectDefaults.kDefaultLayoutNewlineRepresentation);
  }
}
