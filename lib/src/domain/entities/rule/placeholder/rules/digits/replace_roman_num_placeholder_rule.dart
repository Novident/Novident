import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/list_extension.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:numerus/numerus.dart';

final class ReplaceRomanNumberPlaceholderRule with PlaceholderRule {
  const ReplaceRomanNumberPlaceholderRule();

  @protected
  static const String romanNumLowercase = 'r';

  @protected
  static const String romanNumUppercase = 'R';

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
            if (match.group(1) == null) return <Operation>[];
            final String indexType = match.group(2)!;
            final bool isUppercase = indexType == romanNumUppercase;
            final bool isLowercase = indexType == romanNumLowercase;
            final int digitIndex = context.documentVariables.count(
                  match.group(1)!,
                  predicate: (String object) {
                    return object.equals(match.group(1)!);
                  },
                ) +
                1;
            context.documentVariables.add(match.group(1)!);
            String str = (digitIndex < 1 ? 1 : digitIndex).toRomanNumeralString()!;
            if (isUppercase) {
              str = str.toUpperCase();
            } else if (isLowercase) {
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
        final String indexType = match.group(2)!;
        final bool isUppercase = indexType == romanNumUppercase;
        final bool isLowercase = indexType == romanNumLowercase;
        final int digitIndex = context.documentVariables.count(
              match.group(1)!,
              predicate: (String object) {
                return object.equals(match.group(1)!);
              },
            ) +
            1;
        context.documentVariables.add(match.group(1)!);
        String str = (digitIndex < 1 ? 1 : digitIndex).toRomanNumeralString()!;
        if (isUppercase) {
          str = str.toUpperCase();
        } else if (isLowercase) {
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
