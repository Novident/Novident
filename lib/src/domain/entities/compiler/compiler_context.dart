import 'package:novident_remake/src/domain/entities/compiler/compiler_metadata.dart';
import 'package:novident_remake/src/domain/entities/format/replacement_values.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/author/author.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_resource.dart';

class CompilerContext {
  List<DocumentResource> resources;
  //TODO: change it to a map
  // because is more efficient
  // manages a {placeholder: count} map
  List<String> documentVariables;
  bool shouldWritePageOptions;
  Document? currentDocument;
  bool processPlaceholderAtEnd;
  DateTime? time;
  int? runningCompileOnLevel;

  /// If the rules are disabled
  /// then this will take that value
  /// and avoid replace the placeholders
  bool placeholderDisabled;

  /// this is the project name that the user
  /// has, and not the version that is passed
  /// to the metadata of the project
  String rawProjectName;
  String language;
  int charsCount;
  int wordsCount;
  int linecount;
  ReplacementsValues? customPatterns;
  Author author;
  CompilerMetadata metadata;

  /// this is a way that must be defined when the Context is created
  ///
  /// is useful when we need to get a document and, we just have a name or id
  Document? Function(String name) jumpToDocument;

  CompilerContext({
    required this.resources,
    required this.documentVariables,
    required this.shouldWritePageOptions,
    required this.currentDocument,
    required this.language,
    required this.charsCount,
    required this.wordsCount,
    required this.linecount,
    required this.author,
    required this.metadata,
    required this.rawProjectName,
    required this.jumpToDocument,
    required this.placeholderDisabled,
    this.processPlaceholderAtEnd = false,
    this.customPatterns,
    this.time,
  });

  DocumentResource? queryResource(String resourceName) {
    for (final Node node in resources) {
      if (node is NodeHasName &&
          resourceName.equals((node as NodeHasName).nodeName) &&
          node is NodeHasResource) {
        // only doc resource is NodeHasResource
        return node.cast<DocumentResource>();
      }
    }
    return null;
  }

  CompilerContext regenerateContext() {
    return CompilerContext(
      resources: <DocumentResource>[],
      documentVariables: <String>[],
      shouldWritePageOptions: true,
      currentDocument: null,
      language: language,
      charsCount: 0,
      wordsCount: 0,
      linecount: 0,
      author: Author(),
      metadata: CompilerMetadata.starter(),
      rawProjectName: '',
      jumpToDocument: jumpToDocument,
      placeholderDisabled: false,
    );
  }
}
