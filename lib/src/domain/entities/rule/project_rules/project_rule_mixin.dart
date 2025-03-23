import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_status_response.dart';

mixin ProjectRule {
  ProjectStatusResponse isValid(Project project);
}
