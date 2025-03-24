import 'package:novident_remake/src/domain/entities/project/project_configurations.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/utils/id_generators.dart';

class Project {
  final String id;
  final String projectName;
  final Root root;
  final ProjectConfigurations config;

  Project({
    String? id,
    required this.root,
    required this.projectName,
    required this.config,
  }) : id = id ?? IdGenerator.gen(version: 1);

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;
    return id == other.id &&
        projectName == other.projectName &&
        config == other.config &&
        root == other.root;
  }

  @override
  int get hashCode =>
      id.hashCode ^ config.hashCode ^ projectName.hashCode ^ root.hashCode;
}
