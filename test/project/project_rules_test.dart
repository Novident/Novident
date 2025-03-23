import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rules.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/exceptions/bad_project_state_exception.dart';

import 'generators/basic_project.dart';

void main() {
  late Project project;
  setUp(() {
    project = generateBasicProject();
  });

  test('should pass manuscript check', () {
    expect(
      ProjectRules.checkProjectState(project),
      isTrue,
    );
  });

  test('should fail manuscript check', () {
    project.root.removeAt(0, shouldNotify: false);

    expect(
      () => ProjectRules.checkProjectState(project),
      throwsA(
        isA<BadProjectStateException>(),
      ),
    );
  });

  test('should pass trash check', () {
    expect(
      ProjectRules.checkProjectState(project),
      isTrue,
    );
  });

  test('should fail trash check', () {
    project.root.removeLast(shouldNotify: false);
    expect(
      () => ProjectRules.checkProjectState(project),
      throwsA(
        isA<BadProjectStateException>(),
      ),
    );
  });

  test('should pass trash duplicate check', () {
    expect(
      ProjectRules.checkProjectState(project),
      isTrue,
    );
  });

  test('should fail trash check', () {
    project.root.add(
      Folder(
        children: [],
        content: Delta(),
        name: 'Trash2',
        details: NodeDetails.zero(),
        type: FolderType.trash,
      ),
    );
    expect(
      () => ProjectRules.checkProjectState(project),
      throwsA(
        isA<BadProjectStateException>(),
      ),
    );
  });
}
