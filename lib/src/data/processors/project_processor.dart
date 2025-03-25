import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:novident_remake/src/data/processors/processor_configurations.dart';
import 'package:novident_remake/src/data/processors/processor_result.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_metadata.dart';
import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_separators_options.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/author/author.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rules.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/object_extension.dart';
import 'package:novident_remake/src/domain/extensions/project_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_attach_sections.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_value.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ProjectProcessor {
  ProjectProcessor._();
  static final List<Document> _docsProcessed = <Document>[];
  static final Delta _deltaBuffer = Delta();
  static late CompilerContext _context;

  static ProcessorResult process(
      Project project, ProcessorConfiguration configuration) {
    assert(
      ProjectRules.checkProjectState(project),
      'Something is wrong with the project',
    );
    _context = _buildContext(project);
    final List<Document> documents = <Document>[];
    final Format format = project.config.format ?? Format.empty();
    for (final Node node in project.root.where(
      (nd) =>
          nd is Folder &&
          nd.type.isNotTrashFolder &&
          nd.type.isNotResearchFolder &&
          nd.type.isNotTemplatesSheetFolder,
    )) {
      final SectionTypeConfigurations sectionConfig =
          project.config.sectionManager.config;
      if (node is! NodeCanAttachSections) {
        continue;
      }
      final String section = _getSectionForNode(
        node is Folder,
        node.details,
        sectionConfig,
        node.cast<NodeCanAttachSections>().section,
      );

      final Layout? layout = format.getLayoutWhere(
        predicate: (Layout layout) => layout.assignedSection.equals(
          section,
        ),
      );

      if (section.isEmpty || layout.isNull) {
        if (node is NodeHasValue<Delta>) {
          for (final Operation op
              in node.cast<NodeHasValue<Delta>>().value.operations) {
            _deltaBuffer.push(op);
          }
        }
        continue;
      }
      final Delta delta = layout!.build(node, _context);
      final SeparatorOptions separator = layout.separatorSections;
      if (separator.separateBeforeSection.breakAfterUse) {}

      if (node is Document) {
        _docsProcessed.add(node);
      }
      if (node is Folder) {}

      if (separator.separatorAfterSection.breakAfterUse) {}
    }
    if (_deltaBuffer.isNotEmpty) {
      documents.add(
        Document(
          details: NodeDetails.withLevel(0),
          content: Delta.from(_deltaBuffer),
          trashOptions: NodeTrashedOptions.nonTrashed(),
          name: 'Merged document at last',
        ),
      );
      _deltaBuffer.operations.clear();
    }
    return ProcessorResult(documents: documents);
  }

  static void _reloadDocumentsProcess() {
    _docsProcessed.clear();
  }

  static String _getSectionForNode(
    bool isFolder,
    NodeDetails details,
    SectionTypeConfigurations config,
    String section,
  ) {
    if (section.equals(ProjectDefaults.kStructuredBasedSectionId)) {
      final int level = details.level;
      final String? sectionId = config.getSectionIdForLevel(
        level: level,
        selection: isFolder ? Selection.folder : Selection.document,
      );
      return sectionId.nonNull;
    }
    return section;
  }

  static CompilerContext _buildContext(Project project) {
    return CompilerContext(
      resources: project.root.getResources(),
      documentVariables: <String>[],
      shouldWritePageOptions: true,
      currentDocument: null,
      language: 'en',
      charsCount: project.charCount(),
      wordsCount: project.wordCount(),
      linecount: project.lineCount(),
      author: Author(),
      metadata: CompilerMetadata.starter(),
      rawProjectName: project.name,
      placeholderDisabled: project.config.placeholderDisabled,
      jumpToDocument: (String nameOrId) {
        return project.root.visitAllNodes(
            shouldGetNode: (node) =>
                node is NodeHasName &&
                    node.cast<NodeHasName>().nodeName.equals(
                          nameOrId,
                        ) ||
                node.id.equals(nameOrId)) as Document;
      },
    );
  }
}
