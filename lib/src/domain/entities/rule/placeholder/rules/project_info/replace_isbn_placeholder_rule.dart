import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:novident_remake/src/domain/validators/uppercase_validators.dart';

/// Gets replaced with the document title name during the Compile process.
///
/// If the placeholder appears in uppercase, the document title name will be
/// uppercased too.
final class ReplaceISBNPlaceholderRule with PlaceholderRule {
  const ReplaceISBNPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kISBNCodeTitlePattern;

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
            final RegExpMatch? match = pattern.firstMatch(data);
            if (match == null || match.group(1) == null) return <Operation>[];
            final String type = match.group(1)!;
            return <Operation>[
              Operation.insert(
                isUppercase(type)
                    ? context.metadata.isbncode.toUpperCase()
                    : context.metadata.isbncode,
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
        final RegExpMatch? match = pattern.firstMatch(data);
        if (match == null || match.group(1) == null) return <Operation>[];
        final String type = match.group(1)!;
        return <Operation>[
          Operation.insert(
            isUppercase(type)
                ? context.metadata.isbncode.toUpperCase()
                : context.metadata.isbncode,
            attributes,
          ),
        ];
      },
    );
  }
}
