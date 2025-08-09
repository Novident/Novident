import 'package:meta/meta.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/project/project_configurations.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';
import 'package:novident_remake/src/domain/interfaces/project/character_count_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/line_counter_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/word_counter_mixin.dart';
import 'package:novident_remake/src/utils/id_generators.dart';

@immutable
class Project with WordCounterMixin, CharacterCountMixin, LineCounterMixin {
  final String id;
  final String name;
  final Root root;
  final ProjectConfigurations config;

  Project({
    String? id,
    required this.root,
    required this.name,
    required this.config,
    bool searchPositions = false,
  }) : id = id ?? IdGenerator.gen(version: 1) {
    if (searchPositions) {
      config.cache.templatePosition.value = root
              .visitAllNodes(
                  shouldGetNode: (Node node) => node.isTemplatesSheetFolder)
              ?.findNodePath() ??
          <int>[];
    }
    root.attachNotifier(config.cache.listenChanges);
  }

  @override
  int charCount({bool acceptWhitespaces = false}) {
    int chars = 0;
    for (final Node node in root.children) {
      if (node is CharacterCountMixin) {
        chars += node.cast<CharacterCountMixin>().charCount(
              acceptWhitespaces: acceptWhitespaces,
            );
      }
    }
    return chars;
  }

  @override
  int lineCount({bool acceptEmptyLines = true}) {
    int lines = 0;
    for (final Node node in root.children) {
      if (node is LineCounterMixin) {
        lines += node.cast<LineCounterMixin>().lineCount(
              acceptEmptyLines: acceptEmptyLines,
            );
      }
    }
    return lines;
  }

  @override
  int wordCount({bool ignorePunctuation = false}) {
    int words = 0;
    for (final Node node in root.children) {
      if (node is WordCounterMixin) {
        words += node.cast<WordCounterMixin>().wordCount(
              ignorePunctuation: ignorePunctuation,
            );
      }
    }
    return words;
  }

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;
    return id == other.id &&
        name == other.name &&
        config == other.config &&
        root == other.root;
  }

  @override
  int get hashCode =>
      id.hashCode ^ config.hashCode ^ name.hashCode ^ root.hashCode;

  /// close the project
  void dispose() {
    config.cache.dispose();
    root.dispose();
  }
}
