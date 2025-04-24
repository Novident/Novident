import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ResetPlaceholderInvokation with PlaceholderRule {
  const ResetPlaceholderInvokation();

  @override
  RegExp get pattern => ProjectDefaults.kResetCountsInvokation;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, ProcessorContext context) {
    return delta.toQuery
        .replaceAllMapped(
          replaceBuilder: (
            String data,
            Map<String, dynamic>? attributes,
            DeltaRange curRange,
            DeltaRange matchRange,
          ) {
            final RegExpMatch match = pattern.firstMatch(data)!;
            // matches with <$rs(type index)_(namedgroup)>
            // and removes then from document variables to reset count
            if (match.group(1) == null) return <Operation>[];
            final String indexType = match.group(2)!;
            final String? indexGroup = match.group(3);
            if (indexType.equals('all', caseSensitive: false)) {
              context.documentVariables.clear();
              return <Operation>[];
            }
            final String placeholder =
                '<\$$indexType${indexGroup != null ? ':$indexGroup' : ''}>';
            context.documentVariables.remove(placeholder);
            return <Operation>[];
          },
          target: pattern.pattern,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, ProcessorContext context) {
    return query.replaceAllMapped(
      replaceBuilder: (
        String data,
        Map<String, dynamic>? attributes,
        DeltaRange curRange,
        DeltaRange matchRange,
      ) {
        final RegExpMatch match = pattern.firstMatch(data)!;
        // matches with <$rs(type index)_(namedgroup)>
        // and removes then from document variables to reset count
        if (match.group(1) == null) return <Operation>[];
        final String indexType = match.group(2)!;
        final String? indexGroup = match.group(3);
        if (indexType.equals('all', caseSensitive: false)) {
          context.documentVariables.clear();
          return <Operation>[];
        }
        final String placeholder =
            '<\$$indexType${indexGroup != null ? ':$indexGroup' : ''}>';
        context.documentVariables.remove(placeholder);
        return <Operation>[];
      },
      target: pattern.pattern,
    );
  }
}
