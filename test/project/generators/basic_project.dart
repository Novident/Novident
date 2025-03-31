import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/project/project_configurations.dart';
import 'package:novident_remake/src/domain/entities/project/section/section.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_manager.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart'
    show Folder;
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

Project generateBasicProject({
  List<Node>? manuscriptChildren,
  List<Node>? rootNodes,
  SectionTypeConfigurations? sectionConfig,
  List<Section>? sections,
  Format? format,
}) {
  return Project(
    name: 'My project name',
    searchPositions: true,
    config: ProjectConfigurations(
      format: format,
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
        ...?rootNodes,
        Folder(
          content: Delta(),
          name: 'Manuscript',
          folderType: FolderType.manuscript,
          children: <Node>[...?manuscriptChildren],
          details: NodeDetails.zero(),
        ),
        Folder(
          content: Delta(),
          name: 'Research',
          folderType: FolderType.research,
          children: <Node>[],
          details: NodeDetails.zero(),
        ),
        Folder(
          children: <Node>[],
          content: Delta(),
          name: 'Trash',
          folderType: FolderType.trash,
          details: NodeDetails.zero(),
        ),
      ],
    ),
  );
}
