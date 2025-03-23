import 'package:novident_remake/src/domain/entities/project/project.dart';

mixin ProjectRule {
  bool check(Project project);
  String whatFails(Project project);
}
