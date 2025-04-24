import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:numerus/numerus.dart';

final class ReplaceNumCountPlaceholderRule with PlaceholderRule {
  const ReplaceNumCountPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kNumCountPattern;

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
          replaceBuilder: (
            String data,
            Map<String, dynamic>? attributes,
            DeltaRange curRange,
            DeltaRange matchRange,
          ) {
            final RegExpMatch match = pattern.firstMatch(data)!;
            final String? placeholderMatch = match.group(1);
            if (placeholderMatch == null) return <Operation>[];
            int digitIndex = context.documentVariables[placeholderMatch] ?? 0;
            digitIndex++;
            context.documentVariables[placeholderMatch] = digitIndex;
            context.documentVariables.removeEntryWhere(
              predicate: (String key, int value) =>
                  key.equals('<\$s${placeholderMatch.replaceRange(0, 2, '')}'),
            );
            final String str = digitIndex.toRomanNumeralString()!;
            return <Operation>[
              Operation.insert(
                str,
                attributes,
              ),
            ];
          },
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, ProcessorContext context) {
    return query.replaceAllMapped(
      target: pattern.pattern,
      replaceBuilder: (
        String data,
        Map<String, dynamic>? attributes,
        DeltaRange curRange,
        DeltaRange matchRange,
      ) {
        final RegExpMatch match = pattern.firstMatch(data)!;
        final String? placeholderMatch = match.group(1);
        if (placeholderMatch == null) return <Operation>[];
        int digitIndex = context.documentVariables[placeholderMatch] ?? 0;
        digitIndex++;
        context.documentVariables[placeholderMatch] = digitIndex;
        final String str = digitIndex.toRomanNumeralString()!;
        return <Operation>[
          Operation.insert(
            str,
            attributes,
          ),
        ];
      },
    );
  }
}
