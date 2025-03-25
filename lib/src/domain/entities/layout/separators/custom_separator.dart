part of '../separators/layout_separator.dart';

/// Returns the content given by the user
@immutable
class CustomSeparatorStrategy extends LayoutSeparator {
  const CustomSeparatorStrategy({
    required this.breakAfter,
    required this.content,
  });

  @internal
  const CustomSeparatorStrategy.internal()
      : breakAfter = false,
        content = '';

  final bool breakAfter;
  final String content;

  /// This decides if the separator will break the page
  @override
  bool get breakAfterUse => breakAfter;

  @override
  String buildSeparator() {
    return content;
  }

  @override
  String get id => '4';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'content': content,
      'break': breakAfter,
    };
  }

  factory CustomSeparatorStrategy.fromJson(Map<String, dynamic> json) {
    return CustomSeparatorStrategy(
      breakAfter: json['break'] as bool,
      content: json['content'] as String,
    );
  }

  @override
  bool operator ==(covariant CustomSeparatorStrategy other) {
    if (identical(this, other)) return true;
    return id == other.id &&
        content == other.content &&
        breakAfter == other.breakAfter;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ breakAfter.hashCode;
}
