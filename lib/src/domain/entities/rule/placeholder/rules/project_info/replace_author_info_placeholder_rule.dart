import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:novident_remake/src/domain/validators/uppercase_validators.dart';

/// Gets replaced with the author info during the Compile process.
final class ReplaceAuthorInfoPlaceholderRule with PlaceholderRule {
  const ReplaceAuthorInfoPlaceholderRule();

  @protected
  static const String forenameKey = 'forename';

  @protected
  static const String authorKey = 'author';

  @protected
  static const String surnameKey = 'surname';

  @protected
  static const String lastnameKey = 'lastname';

  @protected
  static const String firstnameKey = 'firstname';

  @protected
  static const String fullnameKey = 'fullname';

  @override
  RegExp get pattern => ProjectDefaults.kAuthorPattern;

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
            final String index = match.group(3) ?? 'all';
            String str = '';
            // firstname and forename are equivalent
            if ((type == firstnameKey || type == firstnameKey.toUpperCase()) ||
                (type == forenameKey || type == forenameKey.toUpperCase())) {
              str = context.author.getFirstname(index);
            }
            // lastname and surname are equivalent
            if ((type == lastnameKey || type == lastnameKey.toUpperCase()) ||
                (type == surnameKey || type == surnameKey.toUpperCase())) {
              str = context.author.getLastName(index);
            }
            if ((type == authorKey || type == authorKey.toUpperCase()) ||
                (type == fullnameKey || type == fullnameKey.toUpperCase())) {
              str = context.author.getAuthorName(index);
            }

            return <Operation>[
              Operation.insert(
                isUppercase(type) ? str.toUpperCase() : str,
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
        final String index = match.group(3) ?? 'all';
        String str = '';
        // firstname and forename are equivalent
        if ((type == firstnameKey || type == firstnameKey.toUpperCase()) ||
            (type == forenameKey || type == forenameKey.toUpperCase())) {
          str = context.author.getFirstname(index);
        }
        // lastname and surname are equivalent
        if ((type == lastnameKey || type == lastnameKey.toUpperCase()) ||
            (type == surnameKey || type == surnameKey.toUpperCase())) {
          str = context.author.getLastName(index);
        }
        if ((type == authorKey || type == authorKey.toUpperCase()) ||
            (type == fullnameKey || type == fullnameKey.toUpperCase())) {
          str = context.author.getAuthorName(index);
        }

        return <Operation>[
          Operation.insert(
            isUppercase(type) ? str.toUpperCase() : str,
            attributes,
          ),
        ];
      },
    );
  }
}
