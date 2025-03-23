import 'dart:convert';
import 'package:novident_remake/src/domain/editor_defaults.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';

class SectionAttributes {
  //inline
  final bool bold;
  final bool italic;
  final bool underline;
  final double fontSize;
  final bool strikethrough;
  final double lineHeight;
  final String fontFamily;
  final String? color;
  final String? link; //url
  //block
  final int? levelHeader;
  final String align;
  final int indent;

  SectionAttributes({
    required this.fontSize,
    required this.bold,
    required this.italic,
    required this.underline,
    required this.lineHeight,
    required this.strikethrough,
    required this.align,
    required this.levelHeader,
    this.fontFamily = EditorDefaults.kDefaultFontFamily,
    this.color,
    this.link,
    this.indent = -1,
  })  : assert(lineHeight <= 3.0 && lineHeight >= 1.0, ''),
        assert(indent == -1 || indent > 0 && indent <= 4, 'Invalid indent $indent'),
        assert(
          align.equals('left') ||
              align.equals('right') ||
              align.equals('center') ||
              align.equals('justify'),
          'Alignment: $align is invalid. Only '
          'supported options: [left, right, center, and justify]',
        );

  factory SectionAttributes.common({
    bool? bold,
    bool? italic,
    bool? underline,
    bool? automaticIndent,
    int? levelHeader,
    String? color,
    String? rgbBackground,
    String? fontFamily,
    String? align,
    String? image,
    double? lineHeight,
    double? fontSize,
  }) {
    return SectionAttributes(
      align: align ?? "left",
      bold: bold ?? false,
      italic: italic ?? false,
      strikethrough: false,
      indent: -1,
      link: null,
      levelHeader: levelHeader ?? 0,
      lineHeight: lineHeight ?? 1.0,
      fontFamily: fontFamily ?? EditorDefaults.kDefaultFontFamily,
      fontSize: fontSize ?? 12,
      color: color,
      underline: underline ?? false,
    );
  }

  SectionAttributes copyWith({
    double? fontSize,
    bool? bold,
    bool? italic,
    bool? underline,
    bool? automaticIndent,
    String? fontFamily,
    String? color,
    String? image,
    double? lineHeight,
    bool? strikethrough,
    String? link,
    String? align,
    int? indent,
    int? levelHeader,
  }) {
    return SectionAttributes(
      fontSize: fontSize ?? this.fontSize,
      strikethrough: strikethrough ?? this.strikethrough,
      indent: indent ?? this.indent,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      lineHeight: lineHeight ?? this.lineHeight,
      underline: underline ?? this.underline,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      align: align ?? this.align,
      levelHeader: levelHeader ?? this.levelHeader,
    );
  }

  Map<String, dynamic> toQuillMap({required bool inline}) {
    if (!inline) {
      return <String, dynamic>{
            'line-height': lineHeight,
            'indent': indent,
            'align': align,
            'header': levelHeader,
          }.ignoreIf(predicate: (String key, dynamic value) {
            if (key == 'header' && (value as int) <= 0) return true;
            return value == null ||
                value is bool && !value ||
                value is bool && value == false ||
                value is String && value.isEmpty ||
                value is Map && value.isEmpty ||
                value is int && value <= -1 ||
                value is double && value <= -1;
          }) ??
          <String, dynamic>{};
    }
    return <String, dynamic>{
          'size': fontSize,
          'bold': bold,
          'italic': italic,
          'underline': underline,
          'strikethrough': strikethrough,
          'family': fontFamily,
          'color': color,
        }.ignoreIf(
          predicate: (String key, dynamic value) {
            if (key == 'family') return false;
            return value == null ||
                value is bool && !value ||
                value is String && value.isEmpty ||
                value is Map && value.isEmpty ||
                value is int && value <= -1 ||
                value is double && value <= -1;
          },
        ) ??
        <String, dynamic>{};
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fontSize': fontSize,
      'bold': bold,
      'italic': italic,
      'underline': underline,
      'lineHeight': lineHeight,
      'strike': strikethrough,
      'indent': indent,
      'font_family': fontFamily,
      'color': color,
      'align': align,
      'header': levelHeader,
    };
  }

  factory SectionAttributes.fromMap(Map<String, dynamic> map) {
    return SectionAttributes(
      fontSize: map['font_size'] as double,
      strikethrough: map['strike'] as bool? ?? false,
      bold: map['bold'] as bool,
      italic: map['italic'] as bool,
      link: map['link'] as String?,
      indent: map['indent'] as int? ?? -1,
      underline: map['underline'] as bool,
      lineHeight: map['lineHeight'] as double? ?? 1.0,
      fontFamily: map['font_family'] as String,
      color: map['color'] as String?,
      align: map['align'] as String,
      levelHeader: map['level_header'] is String
          ? int.tryParse(map['level_header'] as String? ?? '-1')!
          : map['level_header'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionAttributes.fromJson(String source) => SectionAttributes.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'SectionAttributes('
        'lineHeight: $lineHeight, '
        'fontSize: $fontSize, '
        'bold: $bold, '
        'italic: $italic, '
        'underline: $underline, '
        'fontFamily: $fontFamily, '
        'color: $color, '
        'align: $align, '
        'levelHeader: $levelHeader'
        ')';
  }
}
