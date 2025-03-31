import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

final class EnsureManuscriptExistenceRule with ProjectRule {
  const EnsureManuscriptExistenceRule();

  @override
  ProjectStatusResponse isValid(Project project) {
    final Node? manuscript = project.root.visitNode(
      shouldGetNode: (Node node) =>
          node is Folder && node.type == FolderType.manuscript,
    );
    final bool isValid = manuscript != null && manuscript.atRoot;
    return ProjectStatusResponse(
      isValid: isValid,
      failReason: isValid
          ? null
          : 'Manuscript folder was not founded at any '
              'point of the Project. This has not the correct '
              'structure and we cannot '
              'import/export it as expected.',
    );
  }
}
