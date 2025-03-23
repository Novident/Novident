import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:novident_remake/src/domain/entities/rule/rules/non_empty_resource_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/rules/only_one_operation_rule.dart';

/// This a base class where we have the rules standard that need to be
/// followed by all the classes that implements [NodeHasResource] mixin
final class ResourceRules {
  const ResourceRules._();
  static final List<ResourceRule> _rules = <ResourceRule>[
    NonEmptyResourceRule(),
    OnlyOneOperationRule(),
  ];

  static bool checkResource(Delta delta) {
    for (final rule in _rules) {
      if (!rule.validate(delta)) {
        return false;
      }
    }
    return true;
  }
}

/// A base mixin to get validate method for common [ResourceRules]
mixin ResourceRule {
  bool validate(Delta delta);
}

