import 'package:novident_remake/src/domain/entities/node/node.dart';

final class ProcessorConfiguration {
  final Node? frontmatter;
  final Node? backmatter;

  ProcessorConfiguration({
    this.frontmatter,
    this.backmatter,
  });
}
