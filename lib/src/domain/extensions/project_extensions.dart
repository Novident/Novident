import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/object_extension.dart';

extension ResourceExtension on Root {
  List<DocumentResource> getResources({bool onlyUseResearch = true}) {
    final List<DocumentResource> resources = <DocumentResource>[];
    if (onlyUseResearch) {
      final Folder? research = visitAllNodes(
        shouldGetNode: (node) => node is Folder && node.type.isResearchFolder,
      ).cast<Folder?>();
      if (research != null) {
        return resources
          ..addAll(research
              .whereDeep((node) => node is DocumentResource && node.isResource)
              .cast<DocumentResource>());
      }
    }
    return resources
      ..addAll(whereDeep(
        (Node node) => node is DocumentResource && node.isResource,
      ).cast<DocumentResource>());
  }

  /// Return all the nodes into the TemplatesSheet folder
  ///
  /// - [templatePosition]: is the index where we can found the template
  ///
  /// _usually, all the projects tracks the position of the template folder_
  /// _to get it fastly without traversing the entire project (even if it is being moved/updated)_
  List<Node> getTemplates({int? templatePosition}) {
    final Folder? template = !templatePosition.isNull
        ? elementAt(templatePosition!).cast<Folder>()
        : visitNode(
            shouldGetNode: (node) =>
                node is Folder && node.type.isTemplatesSheetFolder,
            // commonly, templates sheet is
            // near to the end of the project
            reversed: true,
          ).cast<Folder?>();
    if (template != null) {
      return <Node>[...template.children];
    }
    return <Node>[];
  }
}
