import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceDoubleNumberingPlaceholderRule with PlaceholderRule {
  const ReplaceDoubleNumberingPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kRomanWordNumIndexPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
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
            // matches with <$dn>
            //
            // its output is like:
            // 1.0 -> 1.1 -> 2.5
            if (match.group(1) == null) return <Operation>[];
            double index = 1.0;
            const double increment = 0.1;
            for (String element in context.documentVariables) {
              if (element.equals(match.group(1)!)) {
                index = double.parse((index + increment).toStringAsFixed(1));
              }
            }
            context.documentVariables.add(match.group(1)!);
            // we need to format the strings, because
            // sometimes, the double value that we are creating
            // looks similar to:
            //
            // 1.2000000000002
            // 1.3000000000000003
            return <Operation>[
              Operation.insert(index.toStringAsFixed(1), attributes),
            ];
          },
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replaceAllMapped(
      target: pattern.pattern,
      replaceBuilder: (
        String data,
        Map<String, dynamic>? attributes,
        DeltaRange curRange,
        DeltaRange matchRange,
      ) {
        final RegExpMatch match = pattern.firstMatch(data)!;
        // matches with <$dn>
        //
        // its output is like:
        // 1.0 -> 1.1 -> 2.5
        if (match.group(1) == null) return <Operation>[];
        double index = 1.0;
        const double increment = 0.1;
        for (String element in context.documentVariables) {
          if (element.equals(match.group(1)!)) {
            index = double.parse((index + increment).toStringAsFixed(1));
          }
        }
        context.documentVariables.add(match.group(1)!);
        // we need to format the strings, because
        // sometimes, the double value that we are creating
        // looks similar to:
        //
        // 1.2000000000002
        // 1.3000000000000003
        return <Operation>[
          Operation.insert(index.toStringAsFixed(1), attributes),
        ];
      },
    );
  }
}
