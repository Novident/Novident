part of '../separators/layout_separator.dart';

/// Breaks the current line to
/// separator old and new content by a '\n'
@immutable
class EmptyLineSeparatorStrategy extends LayoutSeparator<String> {
  const EmptyLineSeparatorStrategy._();

  static EmptyLineSeparatorStrategy get instance => _instance == null
      ? _instance = EmptyLineSeparatorStrategy._()
      : _instance!;

  static EmptyLineSeparatorStrategy? _instance;

  @override
  String buildSeparator() {
    return '\n';
  }

  /// This decides if the separator will break the page
  @override
  bool get breakAfterUse => false;

  @override
  String get id => '1';

  @override
  bool operator ==(covariant LayoutSeparator<String> other) {
    if (identical(this, other)) return true;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
