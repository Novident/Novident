import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart'
    show Folder;
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';

Project generateBasicProject() {
  return Project(
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
