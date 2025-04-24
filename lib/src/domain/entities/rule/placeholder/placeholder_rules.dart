import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/dates/replace_day_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/dates/replace_month_placeholder_rules.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/dates/replace_number_dates_placeholder_rules.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/dates/replace_today_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/dates/replace_year_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/digits/replace_double_num_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/digits/replace_num_count_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/digits/replace_roman_num_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/digits/replace_sub_num_count_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/digits/replace_word_num_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_abbreviate_title_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_author_info_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_count_placeholders_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_document_title_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_isbn_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_line_count_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/project_info/replace_project_title_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/replace_image_placeholder_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/rules/reset_invokation_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/type_placeholder_enum.dart';

@immutable
final class PlaceholderRules {
  const PlaceholderRules();
  static final List<PlaceholderRule> _indexRules = <PlaceholderRule>[
    ResetPlaceholderInvokation(),
    ReplaceNumCountPlaceholderRule(),
    ReplaceSubNumCountPlaceholderRule(),
    ReplaceRomanNumberPlaceholderRule(),
    ReplaceDoubleNumberingPlaceholderRule(),
    ReplaceWordNumberPlaceholderRule(),
  ];

  static final List<PlaceholderRule> _dateRules = <PlaceholderRule>[
    ReplaceMinutePlaceholderRule(),
    ReplaceMillisecondsPlaceholderRule(),
    ReplaceMicrosecondsPlaceholderRule(),
    ReplaceSecondsPlaceholderRule(),
    ReplaceHourFormatPlaceholderRule(),
    ReplaceDayPlaceholderRule(),
    ReplaceTodayPlaceholderRule(),
    ReplaceYearPlaceholderRule(),
    ReplaceWeekdayPlaceholderRule(),
    ReplaceMonthPlaceholderRule(),
  ];

  static final List<PlaceholderRule> _projectInfoRules = <PlaceholderRule>[
    // counts
    ReplaceWordCountPlaceholderRule(),
    ReplaceCharacterCountPlaceholderRule(),
    ReplaceLineCountPlaceholderRule(),
    // metadata
    ReplaceImagePlaceholderRule(),
    ReplaceDocumentTitlePlaceholderRule(),
    ReplaceProjectTitlePlaceholderRule(),
    ReplaceAbbreviateTitlePlaceholderRule(),
    ReplaceAuthorInfoPlaceholderRule(),
    ReplaceISBNPlaceholderRule(),
  ];

  Delta applyRules(
      Delta delta, TypePlaceholder type, ProcessorContext context) {
    if (context.placeholderDisabled || delta.isEmpty) return delta;
    QueryDelta query = QueryDelta(delta: delta);
    if (type == TypePlaceholder.all) {
      for (final PlaceholderRule rule in <PlaceholderRule>[
        ..._indexRules,
        ..._dateRules,
        ..._projectInfoRules,
      ]) {
        if (rule.checkIfNeedApply(delta)) {
          query = rule.setConditionRule(query, context);
        }
      }
    }

    if (type == TypePlaceholder.indexs) {
      for (final PlaceholderRule rule in _indexRules) {
        if (rule.checkIfNeedApply(delta)) {
          query = rule.setConditionRule(query, context);
        }
      }
    }
    if (type == TypePlaceholder.dates) {
      context.time = DateTime.now();
      for (final PlaceholderRule rule in _dateRules) {
        if (rule.checkIfNeedApply(delta)) {
          query = rule.setConditionRule(query, context);
        }
      }
    }
    if (type == TypePlaceholder.projectInfo) {
      for (final PlaceholderRule rule in _projectInfoRules) {
        if (rule.checkIfNeedApply(delta)) {
          query = rule.setConditionRule(query, context);
        }
      }
    }

    if (query.params.conditions.isEmpty) {
      return delta;
    }

    return query.build().delta;
  }
}
