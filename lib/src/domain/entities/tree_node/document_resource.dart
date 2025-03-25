import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:flutter_quill/quill_delta.dart' show Delta;
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/rule/resources/resource_rules.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_resource.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_visitor.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_value.dart';
import '../node/node.dart';

/// DocumentResource represents a simple type of node
/// that just contains a resource vlaue
final class DocumentResource extends Node
    with NodeHasValue<Delta>, NodeHasName, NodeCanBeTrashed, NodeHasResource {
  final String name;
  final String extension;
  final Delta content;
  final NodeTrashedOptions trashOptions;

  DocumentResource({
    required super.details,
    required this.content,
    required this.name,
    required this.extension,
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
  });

  DocumentResource.empty({
    required super.details,
    this.extension = '',
    this.name = '',
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
  }) : content = Delta();

  @override
  NodeTrashedOptions get trashStatus => trashOptions;

  @override
  DocumentResource setTrashState() {
    return copyWith(
      trashOptions: NodeTrashedOptions.now(),
    );
  }

  @override
  String get nodeName => name;

  @override
  Delta get value => content;

  @override
  DocumentResource clone() {
    return DocumentResource(
      details: details,
      extension: extension,
      name: name,
      trashOptions: trashOptions,
      content: content,
    );
  }

  @override
  bool deepExist(String id) {
    return this.id == id;
  }

  @override
  bool exist(String id) {
    return this.id == id;
  }

  @override
  DocumentResource? visitAllNodes({required Predicate shouldGetNode}) {
    if (shouldGetNode(this)) return this;
    return null;
  }

  @override
  DocumentResource? visitNode({required Predicate shouldGetNode}) {
    if (shouldGetNode(this)) return this;
    return null;
  }

  @override
  int countAllNodes({required Predicate countNode}) {
    return countNode(this) ? 1 : 0;
  }

  @override
  int countNodes({required Predicate countNode}) {
    return countNode(this) ? 1 : 0;
  }

  static DocumentResource fromJson(Map<String, dynamic> json) {
    if (json['isFile'] == null) {
      throw IllegalTypeConvertionException(
        type: [DocumentResource],
        founded: json['isFolder'] != null
            ? Folder
            : json['isFolder'] != null
                ? Folder
                : json['isRoot'] != null
                    ? Root
                    : null,
      );
    }
    return DocumentResource(
      trashOptions: NodeTrashedOptions.fromJson(
        json['trashOptions'] as Map<String, dynamic>,
      ),
      extension: json['extension'] as String,
      name: json['name'] as String,
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
      'extension': extension,
      'content': content.toJson(),
      'name': name,
      'trashOptions': trashOptions.toJson(),
    };
  }

  @override
  String toString() {
    return 'DocumentResource('
        'details: $details, '
        'content: $content, '
        'synopsis: synopsis, '
        'name: $name.$extension'
        'trashOptions: $trashOptions'
        ')';
  }

  @override
  DocumentResource copyWith({
    NodeDetails? details,
    Delta? content,
    String? name,
    String? attachedSection,
    String? synopsis,
    String? extension,
    NodeTrashedOptions? trashOptions,
  }) {
    return DocumentResource(
      details: details ?? this.details,
      extension: extension ?? this.extension,
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
      name.hashCode ^
      extension.hashCode;

  @override
  bool operator ==(covariant DocumentResource other) {
    if (identical(this, other)) return true;
    return other.details == details &&
        content == other.content &&
        extension.equals(other.extension) &&
        trashOptions == other.trashOptions &&
        name.equals(other.name);
  }

  @override
  bool get isResource => ResourceRules.checkResource(content);

  @override
  Object? resource(ResourceType type) {
    if (!isResource) return null;
    if (type == ResourceType.image) {
      return (content.getFirstEmbed()?.delta.first.data
          as Map<String, dynamic>)['image'] as String;
    }
    return content.getFirstEmbed()?.delta.first.data;
  }
}
