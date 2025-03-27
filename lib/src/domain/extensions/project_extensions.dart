import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';

extension ResourceExtension on Project {
  List<DocumentResource> getResources({bool onlyUseResearch = true}) {
    final List<DocumentResource> resources = <DocumentResource>[];
    if (onlyUseResearch) {
      final Folder? research = root
          .visitAllNodes(
            shouldGetNode: (node) =>
                node is Folder && node.type.isResearchFolder,
          )
          .cast<Folder?>();
      if (research != null) {
        return resources
          ..addAll(research
              .whereDeep((node) => node is DocumentResource && node.isResource)
              .cast<DocumentResource>());
      }
    }
    return resources
      ..addAll(root
          .whereDeep(
            (Node node) => node is DocumentResource && node.isResource,
          )
          .cast<DocumentResource>());
  }

  /// Return TemplatesSheet folder
  Folder? getTemplateSheet() {
    final Folder? template = !config.cache.templatePosition.value.isNegative
        ? root.elementAt(config.cache.templatePosition.value).cast<Folder>()
        : root
            .visitNode(
              shouldGetNode: (Node node) =>
                  node is Folder && node.type.isTemplatesSheetFolder,
              // commonly, templates sheet is
              // near to the end of the project
              reversed: true,
            )
            .cast<Folder?>();
    if (template != null) {
      if (config.cache.templatePosition.value.isNegative) {
        config.cache.templatePosition.value = root.indexOf(
          template,
          root.length - 1,
        );
      }
      return template;
    }
    return null;
  }

  /// Return all the nodes into the TemplatesSheet folder
  ///
  List<Node> getTemplates() {
    final Folder? template = !config.cache.templatePosition.value.isNegative
        ? root.elementAt(config.cache.templatePosition.value).cast<Folder>()
        : root
            .visitNode(
              shouldGetNode: (node) =>
                  node is Folder && node.type.isTemplatesSheetFolder,
              // commonly, templates sheet is
              // near to the end of the project
              reversed: true,
            )
            .cast<Folder?>();
    if (template != null) {
      return <Node>[...template.children];
    }
    return <Node>[];
  }
}
