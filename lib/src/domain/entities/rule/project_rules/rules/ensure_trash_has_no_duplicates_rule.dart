import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

final class EnsureTrashHasNoDuplicatesRule with ProjectRule {
  const EnsureTrashHasNoDuplicatesRule();

  @override
  ProjectStatusResponse isValid(Project project) {
    final int count = project.root.countAllNodes(
        countNode: (Node node) =>
            node is Folder && node.type == FolderType.trash);
    final bool isValid = count == 1;
    return ProjectStatusResponse(
        isValid: isValid,
        failReason: isValid
            ? null
            : 'The current project has more than one($count)'
                'trash folder that it should have'
                'already. This is not a valid '
                'project to be imported/export');
  }
}
