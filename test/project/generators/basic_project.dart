import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/project/project_configurations.dart';
import 'package:novident_remake/src/domain/entities/project/section/section.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_manager.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart' show Folder;
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

Project generateBasicProject({
  List<Node>? manuscriptChildren,
  SectionTypeConfigurations? sectionConfig,
  List<Section>? sections,
}) {
  return Project(
    config: ProjectConfigurations(
      sectionManager: SectionManager(
        sections: <Section>[...?sections],
        config: sectionConfig ??
            SectionTypeConfigurations(
              outlineFolder: <String, String>{},
              outlineDocs: <String, String>{},
            ),
      ),
    ),
    root: Root(
      children: <Node>[
        Folder(
          content: Delta(),
          name: 'Manuscript',
          type: FolderType.manuscript,
          children: <Node>[...?manuscriptChildren],
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
