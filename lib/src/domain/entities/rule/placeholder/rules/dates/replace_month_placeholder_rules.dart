import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceMonthPlaceholderRule with PlaceholderRule {
  const ReplaceMonthPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kMonthsPattern;

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
            if (match.group(1) == null) return <Operation>[];
            final bool isWordMonth = match.group(2) == ':n';
            if (isWordMonth) {
              return <Operation>[
                Constant.kMonths[context.time?.month]!.capitalize().toOperation(
                      attributes,
                    ) as Operation,
              ];
            }
            return <Operation>[
              context.time?.month.toString().toOperation(
                    attributes,
                  ) as Operation,
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
        if (match.group(1) == null) return <Operation>[];
        final bool isWordMonth = match.group(2) == ':n';
        if (isWordMonth) {
          return <Operation>[
            Constant.kMonths[context.time?.month]!.capitalize().toOperation(
                  attributes,
                ) as Operation,
          ];
        }
        return <Operation>[
          context.time?.month.toString().toOperation(
                attributes,
              ) as Operation,
        ];
      },
    );
  }
}
