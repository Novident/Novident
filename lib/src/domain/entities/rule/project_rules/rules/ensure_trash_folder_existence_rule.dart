import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

final class EnsureTrashFolderExistenceRule with ProjectRule {
  const EnsureTrashFolderExistenceRule();

  @override
  bool check(Project project) {
    final Node? trash = project.root.visitNode(
        shouldGetNode: (node) =>
            node is Folder && node.type == FolderType.trash);
    return trash != null;
  }

  @override
  String whatFails(Project project) {
    return 'Trash folder was not founded at any '
        'point of the Project. This has not the correct '
        'structure and we cannot '
        'import/export it as expected.';
  }
}
