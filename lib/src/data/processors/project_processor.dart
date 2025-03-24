import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';

final class ProjectProcessor {
  const ProjectProcessor._();
  static ProcessorResult? process(Project project, ProcessorConfiguration configuration) {
    return null;
  }
}

final class ProcessorConfiguration {
  final Node? frontmatter;
  final Node? backmatter;
  final Format format;

  ProcessorConfiguration({
    required this.format,
    this.frontmatter,
    this.backmatter,
  });
}

final class ProcessorResult {
  final List<Document> documents;

  ProcessorResult({
    required this.documents,
  });
}
