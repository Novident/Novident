import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:novident_remake/src/domain/entities/rule/resource_rules.dart';

/// Checks if the content is not empty
class NonEmptyResourceRule with ResourceRule {
  const NonEmptyResourceRule();
  @override
  bool validate(Delta delta) {
    return delta.isNotEmpty;
  }
}
