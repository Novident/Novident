import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/project/character_count_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/line_counter_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/word_counter_mixin.dart';
import 'package:novident_remake/src/domain/string_contants.dart';

mixin DefaultCountValue<T> {
  T get countValue;
}

mixin DefaultWordCount implements WordCounterMixin, DefaultCountValue<String> {
  @override
  int wordCount({bool ignorePunctuation = false}) {
    int wordCount = 0;
    bool inWord = false;
    for (int i = 0; i < countValue.length; i++) {
      final String tChar = countValue[i];
      final bool punctuationContinue =
          !ignorePunctuation && !tChar.isPunctuation;
      if (tChar.isChar && !tChar.isWhiteSpace && punctuationContinue) {
        if (inWord == false) {
          inWord = true;
        }
      } else {
        if (inWord) wordCount++;
        inWord = false;
      }
    }
    if (inWord) wordCount++;
    return wordCount;
  }
}

mixin DefaultCharCount
    implements CharacterCountMixin, DefaultCountValue<String> {
  @override
  int charCount({bool acceptWhitespaces = false}) {
    if (!acceptWhitespaces) {
      return countValue.runes
          .where(
            StringContants.isChar,
          )
          .length;
    }
    return countValue.runes.length;
  }
}

mixin DefaultLineCount implements LineCounterMixin, DefaultCountValue<String> {
  @override
  int lineCount({bool acceptEmptyLines = true}) {
    int lines = 0;
    for (var i = 1; i < countValue.length; i++) {
      // accepts line and empty lines counting
      if (acceptEmptyLines) {
        if (countValue[i] == '\n') {
          if (i == 0) {
            lines++;
          } else if (countValue[i - 1] == '\n') {
            lines++;
          }
        }
        continue;
      }
      // ensure that is not counting empty lines
      if (countValue[i] == '\n' && countValue[i - 1] != '\n') {
        lines++;
      }
    }
    return lines;
  }
}
