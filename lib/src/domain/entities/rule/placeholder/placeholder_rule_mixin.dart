import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart'
    show CompilerContext;

mixin PlaceholderRule {
  Pattern get pattern;
  bool checkIfNeedApply(Delta delta);
  Delta apply(Delta delta, CompilerContext context);
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context);
}
