import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

final class EnsureResearchExistenceRule with ProjectRule {
  const EnsureResearchExistenceRule();

  @override
  ProjectStatusResponse isValid(Project project) {
    final Node? research = project.root.visitNode(
      shouldGetNode: (Node node) =>
          node is Folder && node.type == FolderType.research,
    );
    final bool isValid = research != null && research.atRoot;
    return ProjectStatusResponse(
      isValid: isValid,
      failReason: isValid
          ? null
          : 'Research folder was not founded at any '
              'point of the Project. This has not the correct '
              'structure and we cannot '
              'import/export it as expected.',
    );
  }
}
