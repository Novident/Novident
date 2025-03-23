part of '../separators/layout_separator.dart';

/// Only return an empty string.
///
/// This strategy just want to allow to the next document
/// to be writted together with the previous content
class SingleReturnSeparatorStrategy extends LayoutSeparator<String> {
  const SingleReturnSeparatorStrategy._();

  static SingleReturnSeparatorStrategy get instance => _instance == null
      ? _instance = SingleReturnSeparatorStrategy._()
      : _instance!;

  static SingleReturnSeparatorStrategy? _instance;

  @override
  String buildSeparator() {
    return '';
  }

  /// This decides if the separator will break the page
  @override
  bool get breakAfterUse => true;

  @override
  String get id => '2';

  @override
  bool operator ==(covariant LayoutSeparator<String> other) {
    if (identical(this, other)) return true;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
