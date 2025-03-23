import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/extensions/project_delta_content_extension.dart';

Delta buildDeltaPart(
  Delta delta,
  CompilerContext context,
) {
  if (delta.isEmpty) return delta;
  return delta.replacePlaceholders(context);
}
