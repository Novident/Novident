import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_manuscript_existence_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_research_existence_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_trash_folder_existence_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_trash_has_no_duplicates_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_trashed_files_are_in_trash_rule.dart';
import 'package:novident_remake/src/domain/exceptions/bad_project_state_exception.dart';

/// These are all the rules that we have to run
/// everytime we import or export a project.
///
/// These rules ensure that the imported/exported project
/// has the correct values, structure, content, and the current
/// standards
class ProjectRules {
  const ProjectRules._();
  static final List<ProjectRule> _rules = <ProjectRule>[
    /// Novident has three default root folders which cannot be deleted or moved from
    /// the top level. They can be renamed and moved around among each other, but
    /// not within each other or other folders. To use Novident effectively, it is very
    /// important to understand the significance of these folders.
    ///
    /// Draft/Manuscript, Research, Trash
    EnsureTrashFolderExistenceRule(),
    EnsureManuscriptExistenceRule(),
    EnsureResearchExistenceRule(),
    // common
    EnsureTrashedNodesAreIntoTrashRule(),
    EnsureTrashHasNoDuplicatesRule(),
  ];

  static bool checkProjectState(Project project) {
    for (final ProjectRule rule in _rules) {
      final ProjectStatusResponse response = rule.isValid(project);
      if (!response.isValid) {
        throw BadProjectStateException(reason: response.failReason!);
      }
    }
    return true;
  }
}
