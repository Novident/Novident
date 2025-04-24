import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

/// Gets replaced with the line count of the document during the Compile process. If
/// associated with an internal document link, the line count will show the number of
/// lines in the linked document.
final class ReplaceLineCountPlaceholderRule with PlaceholderRule {
  const ReplaceLineCountPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kLineCountPattern;

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
          replace: context.linecount.toString(),
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
      replace: context.linecount.toString(),
      range: null,
      onlyOnce: false,
    );
  }
}
