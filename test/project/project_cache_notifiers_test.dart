import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
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

    int position = 0;
    // add listener
    project.config.cache.templatePosition.addNotifier((value) {
      position = value;
    });

    final Folder? template = project.getTemplateSheet().cast<Folder?>();
    expect(template, isNotNull);
    expect(project.root.elementAt(0).id, template!.id);
    expect(project.root.elementAt(0).cast<Folder>().type,
        FolderType.templatesSheet);

    project.root.removeAt(position);
    expect(position, -1,
        reason: 'The current position is $position does not match with -1. '
            'Check if something on the notifiers are not working.');
    template.owner = null;
    project.root.insert(1, template);
    expect(position, 1,
        reason: 'The current position is $position does not match with 1. '
            'Check if the notifiers are working as expected.');

    project.config.cache.dispose();
    expect(project.config.cache.isDisposed, isTrue);
  });
}
