import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/nodes_extensions.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';

final class EnsureTrashedNodesAreIntoTrashRule with ProjectRule {
  const EnsureTrashedNodesAreIntoTrashRule();

  @override
  ProjectStatusResponse isValid(Project project) {
    final Iterable<Node> trashedFiles = project.root.whereDeep((Node node) {
      return !node.isTrashFolder &&
          (node.nodeCanBeTrashed &&
              node.cast<NodeCanBeTrashed>().trashStatus.isTrashed);
    });
    final bool isValid = trashedFiles.isEmpty;
    return ProjectStatusResponse(
      isValid: isValid,
      failReason: isValid
          ? null
          : 'Trash files were founded outside of '
              'the Trash folder. This error cannot let us '
              'import/export correctly the project, since it does not '
              'satify the Novident project Stantard.\n'
              'The files founded are: ${trashedFiles.map((Node e) => e.cast<NodeHasName>().nodeName)}',
    );
  }
}
