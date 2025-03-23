import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

final class EnsureTrashHasNoDuplicatesRule with ProjectRule {
  const EnsureTrashHasNoDuplicatesRule();

  @override
  bool isValid(Project project) {
    final Node? trash = project.root.visitNode(
        shouldGetNode: (node) =>
            node is Folder && node.type == FolderType.trash);
    final Node? duplicateTrash = project.root.visitNode(
        shouldGetNode: (node) =>
            node is Folder &&
            node.type == FolderType.trash &&
            node.id != trash?.id);
    return trash != null && duplicateTrash == null;
  }

  @override
  String whatFails(Project project) {
    return 'The current project has more '
        'trash folder that it should have'
        'already. This is not a valid '
        'project to be imported/export';
  }
}
