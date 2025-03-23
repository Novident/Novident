import 'package:novident_remake/src/domain/entities/project/project.dart';

mixin ProjectRule {
  bool isValid(Project project);
  String whatFails(Project project);
}
