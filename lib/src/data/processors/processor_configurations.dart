import 'package:novident_nodes/novident_nodes.dart';

final class ProcessorConfiguration {
  final Node? frontmatter;
  final Node? backmatter;

  ProcessorConfiguration({
    this.frontmatter,
    this.backmatter,
  });
}
