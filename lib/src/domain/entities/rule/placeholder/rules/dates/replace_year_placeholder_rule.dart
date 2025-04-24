import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceYearPlaceholderRule with PlaceholderRule {
  const ReplaceYearPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kYearPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, ProcessorContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.year}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, ProcessorContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.year}',
      range: null,
      onlyOnce: false,
    );
  }
}
