import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/data/processors/processor_configurations.dart';
import 'package:novident_remake/src/data/processors/processor_result.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_metadata.dart';
import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_separators_options.dart';
import 'package:novident_remake/src/domain/entities/layout/separators/layout_separator.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_container.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/author/author.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/rule/project_rules/project_rules.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';
import 'package:novident_remake/src/domain/interfaces/interfaces.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ProjectProcessor {
  ProjectProcessor._();
  static final List<Node> _nodesBeingProcessed = <Node>[];
  static final Delta _deltaBuffer = Delta();
  static late CompilerContext _context;

  //TODO: implement folder and documents separators (given by Format class)
  static ProcessorResult process(
      Project project, ProcessorConfiguration configuration) {
    assert(
      ProjectRules.checkProjectState(project),
      'Something is wrong with the project',
    );
    _context = _buildContext(project);
    final List<Document> documents = <Document>[];
    final Format format = project.config.format ?? Format.empty();
    _context.runningCompileOnLevel = 0;
    _build(
        documents: documents,
        project: project,
        format: format,
        children: project.root.where(
          (nd) =>
              nd is Folder &&
                  nd.type.isNotTrashFolder &&
                  nd.type.isNotResearchFolder &&
                  nd.type.isNotTemplatesSheetFolder ||
              !nd.isFolder,
        ));

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

  static void _build({
    required List<Document> documents,
    required Project project,
    required Format format,
    required Iterable<Node> children,
  }) {
    for (final Node node in children) {
      // we need to ignore this node types
      if (node is NodeHasResource || node is! NodeCanAttachSections) continue;
      final SectionTypeConfigurations sectionConfig =
          project.config.sectionManager.config;
      final String section = _getSectionForNode(
        node is Folder,
        node.details,
        sectionConfig,
        node.cast<NodeCanAttachSections>().section,
      );
      _nodesBeingProcessed.add(node);

      final Layout? layout = format.getLayoutWhere(
        predicate: (Layout layout) => layout.assignedSection.equals(
          section,
        ),
      );

      final bool hasNoMatch = section.isEmpty || layout.isNull;
      if (hasNoMatch) {
        _onNoSectionMatch(node);
        continue;
      }

      final SeparatorOptions separator = layout!.separatorSections;
      // Since, we do not check, if the node is a Manuscript, TemplatesSheet,
      // Research, or any of that kind
      // we need to check if the node is not a Folder applies the [SeparatorOptions]
      // given by the [Layout]
      //
      // If it is, then must be normal to apply the [SeparatorOptions]
      // given by the [Layout]
      //
      if (!node.isFolder || node.isNormalFolder) {
        final String beforeSeparatorContent =
            separator.separateBeforeSection.buildSeparator();
        final String betweenSeparatorContent =
            separator.separatorBetweenSection.buildSeparator();
        // before
        _deltaBuffer
            .push(beforeSeparatorContent.toOperation().cast<Operation>());
        _onNeedBreak(
            node, documents, separator.separateBeforeSection.breakAfterUse);
        // between
        _deltaBuffer
            .push(betweenSeparatorContent.toOperation().cast<Operation>());
        _onNeedBreak(
            node, documents, separator.separatorBetweenSection.breakAfterUse);
      }

      final Delta delta = layout.applyLayout(node, _context);
      // here we write the content of the node
      delta.operations.forEach(_deltaBuffer.push);

      if (node is NodeContainer && node.isNotEmpty) {
        // sets the new level that will be used during build content
        // to simulates that we are at that point
        _context.runningCompileOnLevel = node.details.level + 1;
        _build(
          documents: documents,
          project: project,
          format: format,
          children: node.children,
        );
        // get the current level again
        _context.runningCompileOnLevel = node.details.level;
      }

      // after separator
      if (!node.isFolder || node.isNormalFolder) {
        final LayoutSeparator afterOption = !separator.overrideSeparatorAfter
            ? SingleReturnSeparatorStrategy.instance
            : separator.separatorAfterSection;
        // if the [breakAfterUse] is true
        // will separate the current content with the next one
        // to simulate that we are creating different pages
        _onNeedBreak(node, documents, afterOption.breakAfterUse);
        _context.shouldWritePageOptions = afterOption.breakAfterUse;
        final String afterSeparatorContent = afterOption.buildSeparator();
        _deltaBuffer
            .push(afterSeparatorContent.toOperation().cast<Operation>());
      }
    }
  }

  static void _reloadDocumentsProcess() {
    _nodesBeingProcessed.clear();
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

  static void _onNoSectionMatch(Node node) {
    if (node is NodeHasValue<Delta>) {
      for (final Operation op
          in node.cast<NodeHasValue<Delta>>().value.operations) {
        _deltaBuffer.push(op);
      }
    }
  }

  /// Breaks the current content with the next one
  static void _onNeedBreak(
      Node node, List<Document> documents, bool needBreak) {
    if (!needBreak) {
      _context.shouldWritePageOptions = false;
      return;
    }
    if (_deltaBuffer.isNotEmpty) {
      documents.add(
        node is Document
            ? node.cast<Document>().copyWith(
                  content: Delta.from(_deltaBuffer),
                  name: _nodesBeingProcessed.length == 1
                      ? node.cast<NodeHasName>().nodeName
                      : _nodesBeingProcessed
                          .cast<NodeHasName>()
                          .map((NodeHasName e) => e.nodeName)
                          .join(','),
                )
            : Document(
                details: node.details,
                content: Delta.from(_deltaBuffer),
                name: node.cast<NodeHasName>().nodeName,
              ),
      );
      _deltaBuffer.operations.clear();
      _reloadDocumentsProcess();
      _context.shouldWritePageOptions = true;
    }
  }

  static CompilerContext _buildContext(Project project) {
    return CompilerContext(
      resources: project.getResources(),
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
