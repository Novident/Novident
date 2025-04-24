import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/extensions/project_delta_content_extension.dart';

Delta buildDeltaPart(
  Delta delta,
  ProcessorContext context,
) {
  if (delta.isEmpty) return delta;
  if (context.processPlaceholderAtEnd) return delta;
  return delta.replacePlaceholders(context);
}
