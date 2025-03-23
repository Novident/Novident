import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rule_mixin.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_manuscript_existence_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_trash_folder_existence_rule.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/rules/ensure_trash_has_no_duplicates_rule.dart';
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
    EnsureTrashFolderExistenceRule(),
    EnsureTrashHasNoDuplicatesRule(),
    EnsureManuscriptExistenceRule(),
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
