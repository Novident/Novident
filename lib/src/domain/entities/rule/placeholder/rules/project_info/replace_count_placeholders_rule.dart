import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

/// Gets replaced during the Compile process with the total word count of the text
/// currently being compiled.
final class ReplaceWordCountPlaceholderRule with PlaceholderRule {
  const ReplaceWordCountPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kWordCountPattern;

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
          replace: context.wordsCount.toString(),
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
      replace: context.wordsCount.toString(),
      range: null,
      onlyOnce: false,
    );
  }
}

/// Gets replaced during the Compile process with the total character count of the
/// text currently being compiled.
final class ReplaceCharacterCountPlaceholderRule with PlaceholderRule {
  const ReplaceCharacterCountPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kCharacterCountPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, ProcessorContext context) {
    return delta.toQuery
        .replaceAllMapped(
            target: pattern.pattern,
            //the first group should prepare the count to end when the max amount of chars ends with (d+) (can be 1.100 or 2.100)
            replaceBuilder: (
              String data,
              Map<String, dynamic>? attributes,
              DeltaRange curRange,
              DeltaRange matchRange,
            ) {
              // the first group should prepare the count to end when
              // the max amount of chars ends with (d+) (can be 1.100 or 2.100)
              return <Operation>[
                context.charsCount.toString().toOperation(
                      attributes,
                    ) as Operation,
              ];
            })
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, ProcessorContext context) {
    return query.replaceAllMapped(
        target: pattern.pattern,
        //the first group should prepare the count to end when the max amount of chars ends with (d+) (can be 1.100 or 2.100)
        replaceBuilder: (
          String data,
          Map<String, dynamic>? attributes,
          DeltaRange curRange,
          DeltaRange matchRange,
        ) {
          // the first group should prepare the count to end when
          // the max amount of chars ends with (d+) (can be 1.100 or 2.100)
          return <Operation>[
            context.charsCount.toString().toOperation(
                  attributes,
                ) as Operation,
          ];
        });
  }
}
