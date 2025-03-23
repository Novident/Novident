import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/rule/resources/resource_rules.dart';

/// Checks if the content only has one Operation
/// and it contains an embed
class OnlyOneOperationRule with ResourceRule {
  const OnlyOneOperationRule();
  @override
  bool validate(Delta delta) {
    return delta.length == 1 && delta.getFirstEmbed() != null;
  }
}
