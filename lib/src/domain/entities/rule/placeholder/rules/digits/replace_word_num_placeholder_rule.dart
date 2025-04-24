import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:humanize_numbers/humanize_numbers.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/list_extension.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceWordNumberPlaceholderRule with PlaceholderRule {
  const ReplaceWordNumberPlaceholderRule();

  @protected
  static final HumanizeNumber parser = HumanizeNumber();

  @protected
  static const String wordNumLowercase = 'w';

  @protected
  static const String wordNumUppercase = 'W';

  @protected
  static const String wordNumTitlecase = 't';

  @override
  RegExp get pattern => ProjectDefaults.kWordNumCountPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern.pattern,
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
            if (match.group(1) == null) return <Operation>[];
            final String? indexType = match.group(2);
            final bool isTitlecase = indexType == wordNumTitlecase;
            final bool isWordNumUppercase = indexType == wordNumUppercase;
            final bool isWordNumLowercase = indexType == wordNumLowercase;
            final int digitIndex = context.documentVariables.count(
                  match.group(1)!,
                  predicate: (String object) {
                    return object.equals(match.group(1)!);
                  },
                ) +
                1;
            context.documentVariables.add(match.group(1)!);
            String str =
                parser.parse(digitIndex < 1 ? 1 : digitIndex, context.language);
            if (isTitlecase) {
              str = str.capitalize();
            } else if (isWordNumUppercase) {
              str = str.toUpperCase();
            } else if (isWordNumLowercase) {
              str = str.toLowerCase();
            }
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
        if (match.group(1) == null) return <Operation>[];
        final String? indexType = match.group(2);
        final bool isTitlecase = indexType == wordNumTitlecase;
        final bool isWordNumUppercase = indexType == wordNumUppercase;
        final bool isWordNumLowercase = indexType == wordNumLowercase;
        final int digitIndex = context.documentVariables.count(
              match.group(1)!,
              predicate: (String object) {
                return object.equals(match.group(1)!);
              },
            ) +
            1;
        context.documentVariables.add(match.group(1)!);
        String str =
            parser.parse(digitIndex < 1 ? 1 : digitIndex, context.language);
        if (isTitlecase) {
          str = str.capitalize();
        } else if (isWordNumUppercase) {
          str = str.toUpperCase();
        } else if (isWordNumLowercase) {
          str = str.toLowerCase();
        }
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
