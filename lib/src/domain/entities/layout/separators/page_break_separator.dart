part of '../separators/layout_separator.dart';

/// Breaks the page of the document to allow to the
/// next content to be writted in a complete different
/// page that the current one
@immutable
class PageBreakSeparatorStrategy extends LayoutSeparator {
  const PageBreakSeparatorStrategy._();

  static PageBreakSeparatorStrategy get instance => _instance == null
      ? _instance = PageBreakSeparatorStrategy._()
      : _instance!;

  static PageBreakSeparatorStrategy? _instance;

  /// This decides if the separator will break the page
  @override
  bool get breakAfterUse => true;

  @override
  String get id => '3';

  @override
  String buildSeparator() {
    return '';
  }

  @override
  bool operator ==(covariant PageBreakSeparatorStrategy other) {
    if (identical(this, other)) return true;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
