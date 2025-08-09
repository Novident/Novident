import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/nodes_extensions.dart';

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
    final Folder? template = config.cache.templatePosition.value.isNotEmpty
        ? root.atPath(config.cache.templatePosition.value).cast<Folder>()
        : root
            .visitAllNodes(
                shouldGetNode: (Node node) => node.isTemplatesSheetFolder)
            .cast<Folder?>();
    if (template != null && config.cache.templatePosition.value.isEmpty) {
      config.cache.templatePosition.value = template.findNodePath();
    }
    return template;
  }

  /// Return all the nodes into the TemplatesSheet folder
  ///
  List<Node> getTemplates() {
    return <Node>[
      ...?getTemplateSheet()?.children,
    ];
  }
}
