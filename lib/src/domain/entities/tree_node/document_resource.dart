import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:novident_remake/src/domain/entities/rule/resources/resource_rules.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/extensions/nodes_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_resource.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_value.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_special_folder_compatibility.dart';

/// DocumentResource represents a simple type of node
/// that just contains a resource vlaue
final class DocumentResource extends Node
    with
        NodeHasValue<Delta>,
        NodeHasName,
        NodeCanBeTrashed,
        NodeHasResource,
        NodeHasSpecialFolderCompatibility {
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

  // Cannot be never into Manuscript folders
  @override
  bool get canMoveIntoSpecialFolders => false;

  // In cases that we let to the project move the resources
  // into the Manuscript, this should allow to the UI
  // show warnings about resources in Manuscript will be ignored
  bool get shouldShowWarningForSpecialFolder => owner == null
      ? false
      : owner!
              .jumpToParent(stopAt: (Node n) => n.isAtRootLevel)
              .isManuscriptFolder &&
          !canMoveIntoSpecialFolders;

  @override
  bool get canMoveIntoAnotherFolders => true;

  @override
  Node unsetTrashState() {
    return copyWith(trashOptions: NodeTrashedOptions.nonTrashed());
  }

  @override
  DocumentResource setTrashState({int end = Folder.kDefaultEndTime}) {
    return copyWith(
      trashOptions: NodeTrashedOptions.now(
        end: end,
      ),
    );
  }

  @override
  String get nodeName => name;

  @override
  Delta get value => content;

  @override
  DocumentResource clone({bool deep = true}) {
    return DocumentResource(
      details: details,
      extension: extension,
      name: name,
      trashOptions: trashOptions,
      content: content,
    );
  }

  @override
  DocumentResource cloneWithNewLevel(int level, {bool deep = true}) {
    return copyWith(
      details: details.cloneWithNewLevel(level),
    );
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
    //TODO: implement pdf, txt, video, unknown cases
    if (type == ResourceType.image) {
      return (content.getFirstEmbed()?.delta.first.data
          as Map<String, dynamic>)['image'] as String;
    }
    return content.getFirstEmbed()?.delta.first.data;
  }
}
