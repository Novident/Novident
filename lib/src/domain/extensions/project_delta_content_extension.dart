import 'package:flutter_quill/quill_delta.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/type_placeholder_enum.dart';
import 'package:novident_remake/src/domain/extensions/delta_extensions.dart';
import 'package:novident_remake/src/utils/attributes_utils.dart';

@internal
extension ProjectDeltaContentExtension on Delta {
  /// Replace all the placeholders keys that are used commonly
  /// into the Novident projects
  Delta replacePlaceholders(ProcessorContext context) {
    return Constant.kDefaultRules.applyRules(
      denormalize(),
      TypePlaceholder.all,
      context,
    );
  }

  /// Replace all the indexes placeholders keys that are used commonly
  /// into the Novident projects
  Delta replaceIndexKeys(ProcessorContext context) {
    return Constant.kDefaultRules.applyRules(
      denormalize(),
      TypePlaceholder.indexs,
      context,
    );
  }

  /// Replace all the project placeholders keys that are used commonly
  /// into the Novident projects
  Delta replaceProjectKeys(
    String name,
    ProcessorContext context,
  ) {
    return Constant.kDefaultRules.applyRules(
      denormalize(),
      TypePlaceholder.projectInfo,
      context,
    );
  }

  /// Replace all the date placeholders keys that are used commonly
  /// into the Novident projects
  Delta replaceDateKeys(ProcessorContext context) {
    return Constant.kDefaultRules.applyRules(
      denormalize(),
      TypePlaceholder.dates,
      context,
    );
  }

  Delta overrideAttributes(
    Map<String, dynamic> inline,
    Map<String, dynamic> blockAttributes,
  ) {
    final Delta denormalized = denormalize();
    final Delta delta = Delta();
    for (final Operation op in denormalized.operations) {
      if (op.data is! String) {
        delta.push(op);
        continue;
      }
      if (op.data == '\n') {
        delta.push(
          Operation.insert(
            op.data,
            op.attributes != null
                ? composeAttributes(op.attributes, blockAttributes)
                : null,
          ),
        );
        continue;
      }
      delta.push(
        Operation.insert(
          op.data,
          inline,
        ),
      );
    }
    return delta;
  }
}
