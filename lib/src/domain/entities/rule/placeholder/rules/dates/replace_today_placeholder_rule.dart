import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceTodayPlaceholderRule with PlaceholderRule {
  const ReplaceTodayPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kTodayPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${Constant.kMonths[context.time?.month]!.capitalize()} '
              '${context.time?.day}, '
              '${context.time?.year}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${Constant.kMonths[context.time?.month]!.capitalize()} '
          '${context.time?.day}, '
          '${context.time?.year}',
      range: null,
      onlyOnce: false,
    );
  }
}

final class ReplaceWeekdayPlaceholderRule with PlaceholderRule {
  const ReplaceWeekdayPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kWeekdayPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.weekday}'.capitalize(),
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.weekday}',
      range: null,
      onlyOnce: false,
    );
  }
}
