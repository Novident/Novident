import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rules.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/exceptions/bad_project_state_exception.dart';

void main() {
  late Project project;

  void init() {
    project = Project(
      root: Root(
        children: <Node>[
          Folder(
            content: Delta(),
            name: 'Manuscript',
            type: FolderType.manuscript,
            children: <Node>[],
            details: NodeDetails.zero(),
          ),
          Folder(
            children: <Node>[],
            content: Delta(),
            name: 'Trash',
            type: FolderType.trash,
            details: NodeDetails.zero(),
          ),
        ],
      ),
      projectName: 'My project name',
    );
  }

  group('manuscript', () {
    init();
    test('should pass manuscript check', () {
      expect(
        ProjectRules.checkProjectState(project),
        isTrue,
      );
    });

    test('should fail manuscript check', () async {
      project.root.removeAt(0);

      await expectLater(
        () => ProjectRules.checkProjectState(project),
        throwsA(
          isA<BadProjectStateException>(),
        ),
      );
      await expectLater(
        () => ProjectRules.checkProjectState(project),
        throwsA(
          BadProjectStateException(
            reason: 'Manuscript folder was not founded at any '
                'point of the Project. This has not the correct '
                'structure and we cannot '
                'import/export it as expected.',
          ),
        ),
      );
    });
  });

  group('trash', () {
    init();
    test('should fail trash check', () async {
      project.root.removeLast();
      await expectLater(
        () => ProjectRules.checkProjectState(project),
        throwsA(
          isA<BadProjectStateException>(),
        ),
      );
      await expectLater(
        () => ProjectRules.checkProjectState(project),
        throwsA(
          BadProjectStateException(
            reason: 'Trash folder was not founded at any '
                'point of the Project. This has not the correct '
                'structure and we cannot '
                'import/export it as expected.',
          ),
        ),
      );
    });
  });

  test('should pass trash check', () async {
    await expectLater(
      ProjectRules.checkProjectState(project),
      isTrue,
    );
  });
}
