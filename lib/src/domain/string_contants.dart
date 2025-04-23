import 'dart:math';

class StringContants {
  const StringContants._();
  static const int kCharacterSpace = 32;
  static const int kCharacterRangeLow = 32;
  static const int kMaxUnicodePoint = 173782;

  static const int kNumberRangeLow = 48;
  static const int kNumberRangeHigh = 57;

  static const int kLowercaseRangeLow = 97;
  static const int kLowercaseRangeHigh = 122;

  static const int kUppercaseRangeLow = 65;
  static const int kUppercaseRangeHigh = 90;

  static const int kPunctuationRangeOneLow = 33;
  static const int kPunctuationRangeOneHigh = 47;

  static const int kPunctuationRangeTwoLow = 58;
  static const int kPunctuationRangeTwoHigh = 64;

  static const int kPunctuationRangeThreeLow = 91;
  static const int kPunctuationRangeThreeHigh = 96;

  static const int kPunctuationRangeFourLow = 123;
  static const int kPunctuationRangeFourHigh = 126;
  static final Random ran = Random(DateTime.now().millisecondsSinceEpoch);

  // Check if the parameter character is a number
  static bool isNumeric(int char) {
    return char >= StringContants.kNumberRangeLow &&
        char <= StringContants.kNumberRangeHigh;
  }

  // Check if the parameter character is punctuation
  static bool isPunctuation(int char) {
    return (char >= StringContants.kPunctuationRangeOneLow &&
            char <= StringContants.kPunctuationRangeOneHigh) ||
        (char >= StringContants.kPunctuationRangeTwoLow &&
            char <= StringContants.kPunctuationRangeTwoHigh) ||
        (char >= StringContants.kPunctuationRangeThreeLow &&
            char <= StringContants.kPunctuationRangeThreeHigh) ||
        (char >= StringContants.kPunctuationRangeFourLow &&
            char <= StringContants.kPunctuationRangeFourHigh);
  }

  // Check if the parameter character is a char.
  // Defined as not null and above the special character range.
  static bool isChar(int char) {
    return char >= StringContants.kCharacterRangeLow;
  }

  // Check if parameter character code point is white space.
  // Defined using regular expression /\s/.
  static bool isWhiteSpace(int char) =>
      RegExp(r'\s').hasMatch(String.fromCharCode(char));

  // Generate a random unicode string of given length.
  static String generateUnicodeString(int length) {
    int ranInt() =>
        ran.nextInt(
          StringContants.kMaxUnicodePoint - StringContants.kNumberRangeLow + 1,
        ) +
        StringContants.kNumberRangeLow;
    return String.fromCharCodes(() sync* {
      var i = 0;
      while (i++ < length) {
        yield ranInt();
      }
    }());
  }
}
