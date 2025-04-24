import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';

/// This is the base ruler for all the placeholders
mixin PlaceholderRule {
  /// The placeholder pattern (usually passed using [ProjectDefaults.placeholder])
  Pattern get pattern;

  /// Determines if we really need to apply or set a replace condition to our Delta
  bool checkIfNeedApply(Delta delta);

  /// Apply the change directly to the Delta
  Delta apply(Delta delta, ProcessorContext context);

  /// Set a [ReplaceCondition] condition [to] a QueryDelta to be builded later
  ///
  /// Usually improves the perfomance of the replace operations
  QueryDelta setConditionRule(QueryDelta query, ProcessorContext context);
}
