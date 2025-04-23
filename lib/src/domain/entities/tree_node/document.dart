import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart' show Delta;
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_attach_sections.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_value.dart';
import 'package:novident_remake/src/domain/interfaces/project/character_count_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/default_counts_impl.dart';
import 'package:novident_remake/src/domain/interfaces/project/line_counter_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/project/word_counter_mixin.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:novident_nodes/novident_nodes.dart';

/// Document represents a simple type of node
///
/// You can see this implementation as a file from a directory
/// that can contain all type data into itself
final class Document extends Node
    with
        NodeHasValue<Delta>,
        NodeHasName,
        NodeCanBeTrashed,
        NodeCanAttachSections,
        WordCounterMixin,
        CharacterCountMixin,
        LineCounterMixin,
        DefaultWordCount,
        DefaultCharCount,
        DefaultLineCount {
  final String name;
  final String attachedSection;
  final Delta content;
  final String synopsis;
  final NodeTrashedOptions trashOptions;

  Document({
    required super.details,
    required this.content,
    required this.name,
    this.attachedSection = ProjectDefaults.kStructuredBasedSectionId,
    this.synopsis = '',
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
  });

  Document.empty({
    required super.details,
    this.name = '',
    this.attachedSection = '',
    this.synopsis = '',
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
  }) : content = Delta();

  @override
  String get countValue => content.toPlain();

  @override
  String get section => attachedSection;

  @override
  NodeTrashedOptions get trashStatus => trashOptions;

  @override
  Document setTrashState() {
    return copyWith(
      trashOptions: NodeTrashedOptions.now(),
    );
  }

  @override
  String get nodeName => name;

  @override
  Delta get value => content;

  @override
  Document clone() {
    return Document(
      details: details,
      name: name,
      synopsis: synopsis,
      trashOptions: trashOptions,
      attachedSection: attachedSection,
      content: content,
    );
  }

  @override
  Node cloneWithNewLevel(int level) {
    return copyWith(
      details: details.cloneWithNewLevel(level),
    );
  }

  static Document fromJson(Map<String, dynamic> json) {
    if (json['isFile'] == null) {
      throw IllegalTypeConvertionException(
        type: [Document],
        founded: json['isFolder'] != null
            ? Folder
            : json['isFolder'] != null
                ? Folder
                : json['isRoot'] != null
                    ? Root
                    : null,
      );
    }
    return Document(
      synopsis: json['synopsis'] as String? ?? '',
      trashOptions:
          NodeTrashedOptions.fromJson(json['trashOptions'] as Map<String, dynamic>),
      name: json['name'] as String,
      attachedSection: json['attachedSection'] as String,
      details: NodeDetails.fromJson(json['details'] as Map<String, dynamic>),
      content: Delta.fromJson(
        json['content'] as List<dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isFile': true,
      'details': details.toJson(),
      'content': content.toJson(),
      'synopsis': synopsis,
      'attachedSection': attachedSection,
      'name': name,
      'trashOptions': trashOptions.toJson(),
    };
  }

  @override
  String toString() {
    return 'Document('
        'details: $details, '
        'content: $content, '
        'attachedSection: $attachedSection,'
        'synopsis: synopsis, '
        'name: $name'
        'trashOptions: $trashOptions'
        ')';
  }

  @override
  Document copyWith({
    NodeDetails? details,
    Delta? content,
    String? name,
    String? attachedSection,
    String? synopsis,
    NodeTrashedOptions? trashOptions,
  }) {
    return Document(
      details: details ?? this.details,
      synopsis: synopsis ?? this.synopsis,
      attachedSection: attachedSection ?? this.attachedSection,
      content: content ?? this.content,
      name: name ?? this.name,
      trashOptions: trashOptions ?? this.trashOptions,
    );
  }

  @override
  int get hashCode =>
      details.hashCode ^
      content.hashCode ^
      trashOptions.hashCode ^
      attachedSection.hashCode ^
      name.hashCode ^
      synopsis.hashCode;

  @override
  bool operator ==(covariant Document other) {
    if (identical(this, other)) return true;
    return other.details == details &&
        content == other.content &&
        trashOptions == other.trashOptions &&
        attachedSection.equals(other.attachedSection) &&
        synopsis.equals(other.synopsis) &&
        name == other.name;
  }
}
