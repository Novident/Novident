import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_container.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_value.dart';
import 'package:novident_remake/src/domain/logger/tree_logger.dart';

/// [Folder] represents a node that can contains all
/// types of Nodes as its children
///
/// You can take this implementation as a directory from your
/// local storage that can contains a wide variety of file types
final class Folder extends NodeContainer
    with NodeHasValue<Delta>, NodeHasName, NodeCanBeTrashed {
  final FolderType type;
  final NodeTrashedOptions trashOptions;
  final String name;
  final Delta content;

  /// If expanded is true the [Folder]
  /// should show the children into it
  bool _isExpanded;

  Folder({
    required super.children,
    required this.content,
    required this.name,
    required super.details,
    this.type = FolderType.normal,
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
    bool isExpanded = false,
    bool doRedepthCheck = false,
  }) : _isExpanded = isExpanded {
    for (final Node child in super.children) {
      child.owner = this;
    }
    if (doRedepthCheck) {
      redepthChildren(checkFirst: true);
    }
  }

  @visibleForTesting
  Folder.testing({
    required super.children,
    required this.content,
    required this.name,
    required super.details,
    this.type = FolderType.normal,
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
    bool isExpanded = false,
  }) : _isExpanded = isExpanded;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool expand) {
    _isExpanded = expand;
    notify();
  }

  @override
  NodeTrashedOptions get trashStatus => trashOptions;

  @override
  Folder setTrashState() {
    return copyWith(trashOptions: NodeTrashedOptions.now());
  }

  @override
  String get nodeName => name;

  @override
  Delta get value => content;

  void openOrClose({bool forceOpen = false}) {
    isExpanded = forceOpen ? true : !isExpanded;
    final forceMessage = forceOpen ? 'forced to be ' : '';
    TreeLogger.internalNodes.info(
      '$runtimeType(id: '
      '${id.shortString()} '
      '$forceMessage'
      'opened/closed by user interaction',
    );
    notify();
  }

  /// adjust the depth level of the children
  void redepthChildren({int? currentLevel, bool checkFirst = false}) {
    assert(level >= 0, 'level cannot be less than zero');
    final Node? parent = type == FolderType.trash
        ? null
        : jumpToParent(
            stopAt: (Node node) =>
                node is Folder && node.type == FolderType.trash);
    final bool trashChildrenIfNeeded =
        parent != null || type == FolderType.trash;

    void redepth(List<Node> unformattedChildren, int currentLevel) {
      currentLevel = level;

      for (int i = 0; i < unformattedChildren.length; i++) {
        final Node node = unformattedChildren.elementAt(i);
        if (trashChildrenIfNeeded && node is NodeCanBeTrashed) {
          if (!node.cast<NodeCanBeTrashed>().trashStatus.isTrashed) {
            unformattedChildren[i] =
                node.cast<NodeCanBeTrashed>().setTrashState().copyWith(
                      details: node.details.copyWith(level: currentLevel + 1),
                    );
            continue;
          }
        }
        unformattedChildren[i] = node.copyWith(
          details: node.details.copyWith(level: currentLevel + 1),
        );
        if (node is NodeContainer && node.isNotEmpty) {
          redepth(node.children, currentLevel + 1);
        }
      }
    }

    bool ignoreRedepth = false;
    if (checkFirst) {
      final int childLevel = level + 1;
      for (final Node child in children) {
        if (child.level != childLevel) {
          ignoreRedepth = true;
          break;
        }
      }
    }
    if (ignoreRedepth) return;

    redepth(children, currentLevel ?? level);
    notify();
  }

  @override
  Folder copyWith({
    NodeDetails? details,
    Delta? content,
    String? name,
    FolderType? type,
    NodeTrashedOptions? trashOptions,
    List<Node>? children,
    bool? isExpanded,
  }) {
    return Folder(
      children: children ?? this.children,
      details: details ?? this.details,
      type: type ?? this.type,
      trashOptions: trashOptions ?? this.trashOptions,
      isExpanded: isExpanded ?? this.isExpanded,
      name: name ?? this.name,
      content: content ?? this.content,
    );
  }

  @override
  Folder clone() {
    return Folder(
      children: children
          .map(
            (e) => e.clone(),
          )
          .toList(),
      name: name,
      trashOptions: trashOptions.clone(),
      content: Delta.from(content),
      details: details,
      isExpanded: isExpanded,
    );
  }

  /// Check if the id of the node exist into the [Folder]
  /// checking in its children using a custom predicate passed by the dev
  ///
  /// This opertion could be heavy based on the deep of the nodes
  /// into the [Folder]
  bool existNodeWhere(bool Function(Node node) predicate,
      [List<Node>? subChildren]) {
    final currentChildren = subChildren;
    for (int i = 0; i < (currentChildren ?? children).length; i++) {
      final node = (currentChildren ?? children).elementAt(i);
      if (predicate(node)) {
        return true;
      } else if (node is Folder && node.isNotEmpty) {
        final foundedNode = existNodeWhere(predicate, node.children);
        if (foundedNode) return true;
      }
    }
    return false;
  }

  Node? childBeforeThis(NodeDetails node, bool alsoInChildren,
      [int? indexNode]) {
    if (indexNode != null) {
      final element = elementAtOrNull(indexNode);
      if (element != null) {
        if (indexNode == 0) return null;
        return elementAt(indexNode - 1);
      }
    }
    for (int i = 0; i < length; i++) {
      final treeNode = elementAt(i);
      if (treeNode.details.id == node.id) {
        if (i - 1 == -1) return null;
        return elementAt(i - 1);
      } else if (treeNode is Folder && treeNode.isNotEmpty && alsoInChildren) {
        final backNode =
            treeNode.childBeforeThis(node, alsoInChildren, indexNode);
        if (backNode != null) return backNode;
      }
    }
    return null;
  }

  Node? childAfterThis(NodeDetails node, bool alsoInChildren,
      [int? indexNode]) {
    if (indexNode != null) {
      final element = elementAtOrNull(indexNode);
      if (element != null) {
        if (indexNode + 1 >= length) return null;
        return elementAt(indexNode + 1);
      }
    }
    for (int i = 0; i < length; i++) {
      final treeNode = elementAt(i);
      if (treeNode.details.id == node.id) {
        if (i + 1 >= length) return null;
        return elementAt(i + 1);
      } else if (treeNode is Folder && treeNode.isNotEmpty && alsoInChildren) {
        final nextChild =
            treeNode.childAfterThis(node, alsoInChildren, indexNode);
        if (nextChild != null) return nextChild;
      }
    }
    return null;
  }

  @visibleForTesting
  static Folder? fromJsonTest(Map<String, dynamic> json) {
    if (json['isFolder'] == null) {
      throw IllegalTypeConvertionException(
        type: [Folder],
        founded: json['isFile'] != null
            ? Document
            : json['isRoot'] != null
                ? Root
                : null,
      );
    }
    return Folder.testing(
      children: List.from(
        json['children'] is! String
            ? (json['children'] as List<dynamic>).map((el) {
                if (el['isRoot'] != null) {
                  throw IllegalTypeConvertionException(
                    type: [Document, Folder],
                    founded: Root,
                  );
                }
                if (el['isFile'] != null) {
                  return Document.fromJson(el as Map<String, dynamic>);
                }
                if (el['isFolder'] != null) {
                  final Folder? folder =
                      Folder.fromJsonTest(el as Map<String, dynamic>);
                  return folder!;
                }
                throw Exception(
                  'The element $el does not contain knowed '
                  'types supported. Expected Document or Folder types',
                );
              })
            : (jsonDecode(json['children'] as String) as List<String>)
                .map<Node>(
                (element) {
                  final map = jsonDecode(element) as Map<String, dynamic>;
                  if (map['isRoot'] != null) {
                    throw IllegalTypeConvertionException(
                      type: [Document, Folder],
                      founded: Root,
                    );
                  }
                  if (map['isFile'] != null) {
                    return Document.fromJson(map);
                  }
                  if (map['isFolder'] != null) {
                    final Folder? folder = Folder.fromJsonTest(map);
                    return folder!;
                  }
                  throw Exception(
                    'The element $map does not contain knowed '
                    'types supported. Expected Document or Folder types',
                  );
                },
              ),
      ),
      name: json['name'] as String,
      type: FolderType.values[json['type'] as int? ?? 0],
      trashOptions: NodeTrashedOptions.fromJson(
          json['trashOptions'] as Map<String, dynamic>),
      isExpanded: json['expanded'] as bool,
      details: NodeDetails.fromJson(
        (json['details'] is String
            ? jsonDecode(json['details'] as String)
            : json['details']) as Map<String, dynamic>,
      ),
      content: Delta.fromJson(json['content'] as List<dynamic>),
    );
  }

  static Folder? fromJson(Map<String, dynamic> json) {
    if (json['isFolder'] == null) {
      throw IllegalTypeConvertionException(
        type: [Folder],
        founded: json['isFile'] != null
            ? Document
            : json['isRoot'] != null
                ? Root
                : null,
      );
    }
    return Folder(
      details: NodeDetails.fromJson(
        json['details'] as Map<String, dynamic>,
      ),
      content: Delta.fromJson(json['content'] as List<dynamic>),
      trashOptions: NodeTrashedOptions.fromJson(
          json['trashOptions'] as Map<String, dynamic>),
      name: json['name'] as String,
      isExpanded: json['expanded'] as bool,
      type: FolderType.values[json['type'] as int? ?? 0],
      children: List.from(
        (json['children'] as List<dynamic>).map(
          (el) {
            if (el['isRoot'] != null) {
              throw IllegalTypeConvertionException(
                type: [Document, Folder],
                founded: Root,
              );
            }
            if (el['isFile'] != null) {
              return Document.fromJson(el as Map<String, dynamic>);
            }
            if (el['isFolder'] != null) {
              final Folder? folder =
                  Folder.fromJson(el as Map<String, dynamic>);
              return folder!;
            }
            throw Exception(
              'The element $el does not contain knowed '
              'types supported. Expected Document or Folder types',
            );
          },
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isFolder': true,
      'details': details.toJson(),
      'type': type.index,
      'content': content.toJson(),
      'name': name,
      'trashOptions': trashOptions.toJson(),
      'children': children
          .map(
            (Node e) => e.toJson(),
          )
          .toList(),
      'expanded': _isExpanded,
    };
  }

  @override
  void dispose() {
    super.dispose();
    for (final Node e in children) {
      ChangeNotifier.debugAssertNotDisposed(this);
      e.dispose();
    }
  }

  @override
  int get hashCode =>
      details.hashCode ^
      isExpanded.hashCode ^
      children.hashCode ^
      name.hashCode ^
      type.hashCode ^
      trashOptions.hashCode ^
      content.hashCode;

  @override
  bool operator ==(covariant Folder other) {
    if (identical(this, other)) return true;
    return details == other.details &&
        isExpanded == other.isExpanded &&
        _equality.equals(
          children,
          other.children,
        ) &&
        name == other.name &&
        type == other.type &&
        trashOptions == other.trashOptions &&
        content == other.content;
  }

  @override
  String toString() {
    return 'Folder('
        'details: $details, '
        'isOpen: $isExpanded, '
        'trashOptions: $trashOptions, '
        'name: $name, '
        'content: $content, '
        'type: ${type.name},'
        'children: $children'
        ')';
  }
}

const ListEquality<Node> _equality = ListEquality();
