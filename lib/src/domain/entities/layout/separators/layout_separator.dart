// ignore_for_file: unused_element, unused_field
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/exceptions/unknown_layout_separator_exception.dart';

part 'single_return_separator.dart';
part 'empty_line_separator.dart';
part 'page_break_separator.dart';
part 'custom_separator.dart';

/// Builds a Separators that will be used after use of
/// transform() from the Layout class
///
/// This is a simple base class that give the use a necessary
/// methods to build a correct separator. Some of the implemented
/// strategies are:
///
/// * [PageBreakSeparatorStrategy]: Breaks the page of the document to allow to the next content to be writted in a complete different page that the current one.
/// * [SingleReturnSeparatorStrategy]: Only return an empty string, since this strategy just want to allow to the next document to be writted together with the previous content.
/// * [CustomSeparatorStrategy]: Returns the content given by the user.
/// * EmptyLineSeparatorStrategy: Breaks the current line to separator old and new content by a '\n'.
@immutable
abstract class LayoutSeparator {
  const LayoutSeparator();

  /// This decides if the separator will break the page
  @mustBeOverridden
  bool get breakAfterUse;

  String buildSeparator();

  /// This is the id that identifies to that separator
  /// every id must be different
  @mustBeOverridden
  String get id;

  @override
  @mustBeOverridden
  bool operator ==(covariant LayoutSeparator other);

  @override
  @mustBeOverridden
  int get hashCode;

  @mustCallSuper
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      LayoutSeparator.separatorIdKey: id,
    };
  }

  static LayoutSeparator? fromJson(Map<String, dynamic> json) {
    final String id = json[LayoutSeparator.separatorIdKey] as String? ?? '';
    final String customSeparatorStrategyId =
        CustomSeparatorStrategy.internal().id;
    final String pageBreakId = PageBreakSeparatorStrategy.instance.id;
    final String emptyLineId = EmptyLineSeparatorStrategy.instance.id;
    final String singleReturnId = SingleReturnSeparatorStrategy.instance.id;
    if (id == customSeparatorStrategyId) {
      return CustomSeparatorStrategy.fromJson(json);
    } else if (id == pageBreakId) {
      return PageBreakSeparatorStrategy.instance;
    } else if (id == emptyLineId) {
      return EmptyLineSeparatorStrategy.instance;
    } else if (id == singleReturnId) {
      return SingleReturnSeparatorStrategy.instance;
    }
    throw UnknownLayoutSeparatorException(id: id);
  }

  @protected
  @visibleForTesting
  static const String separatorIdKey = 'separatorId';
}

// This is the old implementation that was used to know, how will need
// to separate the sections after a layout build
//
// Was deprecated since it does not work if we need more arguments or different
// behaviors depending of how the strategy is created
@Deprecated('')
enum __LayoutSeparator {
  // just add a new line empty and put the content
  emptyLine,
  // Close the current page and open another
  // for add the content of the doc
  pageBreak,
  // just continue without add any content at this point
  singleReturn,
  // just add the content what the user write
  // in content (related with SeparatorOption)
  custom,
}
