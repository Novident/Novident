import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/project_extensions.dart';
import 'generators/basic_project.dart';

void main() {
  test('should notify when we remove and insert the TemplatesSheet folder',
      () async {
    final Project project = generateBasicProject(
      rootNodes: <Node>[
        Folder(
          children: <Node>[],
          content: Delta(),
          folderType: FolderType.templatesSheet,
          name: 'Template Sheet',
          details: NodeDetails.zero(),
        ),
      ],
    );

    List<int> position = [0];
    // add listener
    project.config.cache.templatePosition.addNotifier((value) {
      position = value;
    });

    final Folder? template = project.getTemplateSheet().cast<Folder?>();
    expect(template, isNotNull);
    expect(project.root.atPath(position)?.id, template!.id);
    expect(project.root.atPath(position)?.cast<Folder?>()?.type,
        FolderType.templatesSheet);

    project.root.atPath(position)?.owner?.remove(template);
    expect(position, <int>[],
        reason:
            'The current position is $position does not match with <int>[]. '
            'Check if something on the notifiers are not working.');
    expect(template.owner, isNull,
        reason: 'template should be unlinked from '
            'its owner after remove event');
    project.root.insert(1, template);
    expect(position, <int>[1],
        reason: 'The current position is $position does not match with 1. '
            'Check if the notifiers are working as expected.');
    expect(template.owner, isNotNull,
        reason: 'template should be linked from '
            'its owner after insert event');

    project.config.cache.dispose();
    expect(project.config.cache.isDisposed, isTrue);
  });
}
