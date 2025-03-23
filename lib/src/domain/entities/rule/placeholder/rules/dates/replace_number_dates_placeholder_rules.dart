import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceMillisecondsPlaceholderRule with PlaceholderRule {
  const ReplaceMillisecondsPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kMillisecondPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.millisecond}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.millisecond}',
      range: null,
      onlyOnce: false,
    );
  }
}

final class ReplaceMicrosecondsPlaceholderRule with PlaceholderRule {
  const ReplaceMicrosecondsPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kMicrosecondPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.microsecond}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.microsecond}',
      range: null,
      onlyOnce: false,
    );
  }
}

final class ReplaceSecondsPlaceholderRule with PlaceholderRule {
  const ReplaceSecondsPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kSecondPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.second}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.second}',
      range: null,
      onlyOnce: false,
    );
  }
}

final class ReplaceMinutePlaceholderRule with PlaceholderRule {
  const ReplaceMinutePlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kMinutePattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: '${context.time?.minute}',
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: '${context.time?.minute}',
      range: null,
      onlyOnce: false,
    );
  }
}

final class ReplaceHourFormatPlaceholderRule with PlaceholderRule {
  const ReplaceHourFormatPlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kHourFormatPattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replace(
          target: pattern.pattern,
          replace: DateFormat('HH:mm:ss').format(context.time!),
          range: null,
          onlyOnce: false,
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replace(
      target: pattern.pattern,
      replace: DateFormat('HH:mm:ss').format(context.time!),
      range: null,
      onlyOnce: false,
    );
  }
}
