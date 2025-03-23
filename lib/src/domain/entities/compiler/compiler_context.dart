import 'package:novident_remake/src/domain/entities/compiler/compiler_metadata.dart';
import 'package:novident_remake/src/domain/entities/format/replacement_values.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/project/author/author.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_name.dart';

class CompilerContext {
  List<Node> resources;
  //TODO: change it to a map
  // because is more efficient
  // manages a {placeholder: count} map
  List<String> documentVariables;
  bool shouldWritePageOptions;
  Document currentDocument;
  final String language;
  final int charsCount;
  final int wordsCount;
  final int linecount;
  final ReplacementsValues? customPatterns;
  final Author author;
  final CompilerMetadata metadata;

  /// If the rules are disabled
  /// then this will take that value
  /// and avoid replace the placeholders
  final bool placeholderDisabled;

  /// this is the project name that the user
  /// has, and not the version that is passed
  /// to the metadata of the project
  final String rawProjectName;
  DateTime? time;

  /// this is a way that must be defined when the Context is created
  ///
  /// is useful when we need to get a document and, we just have a name or id
  final Document? Function(String name) jumpToDocument;

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
    this.customPatterns,
    this.time,
  });

  Node? queryResource(String resourceName) {
    for (final Node node in resources) {
      if (node is NodeHasName &&
          resourceName.equals((node as NodeHasName).nodeName)) {
        return node;
      }
    }
    return null;
  }
}
