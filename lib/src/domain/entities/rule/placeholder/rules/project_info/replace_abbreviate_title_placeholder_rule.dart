import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:novident_remake/src/domain/validators/uppercase_validators.dart';

/// Gets replaced with the abbreviated project name during the Compile process.
/// The abbreviated project name is taken from metadata pane of the Compile panel.
///
/// If the placeholder appears in uppercase, the abbreviated project name will be
/// uppercased too.
final class ReplaceAbbreviateTitlePlaceholderRule with PlaceholderRule {
  const ReplaceAbbreviateTitlePlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kAbbreviateTitlePattern;

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
            final RegExpMatch? match = pattern.firstMatch(data);
            if (match == null || match.group(1) == null) return <Operation>[];
            final String type = match.group(1)!;
            return <Operation>[
              Operation.insert(
                isUppercase(type)
                    ? context.metadata.abbreviateTitle.toUpperCase()
                    : context.metadata.abbreviateTitle,
                attributes,
              ),
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
        final RegExpMatch? match = pattern.firstMatch(data);
        if (match == null || match.group(1) == null) return <Operation>[];
        final String type = match.group(1)!;
        return <Operation>[
          Operation.insert(
            isUppercase(type)
                ? context.metadata.abbreviateTitle.toUpperCase()
                : context.metadata.abbreviateTitle,
            attributes,
          ),
        ];
      },
    );
  }
}
