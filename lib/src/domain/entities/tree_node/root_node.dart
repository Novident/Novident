import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_container.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';

/// [Root] represents the main tree part of the tree, where
/// all the files are being contained
final class Root extends NodeContainer {
  Root({
    required super.children,
  })  : assert(
          children.whereType<Root>().isEmpty,
          'Root children cannot '
          'contain any Root node type',
        ),
        super(
          details: NodeDetails.withLevel(
            -1,
          ),
        ) {
    for (final Node child in children) {
      child.owner = this;
    }
    redepthChildren(checkFirst: true);
  }

  @visibleForTesting
  Root.testing({
    required super.children,
  })  : assert(
          children.whereType<Root>().isEmpty,
          'Root children cannot '
          'contain other Root\'s node type',
        ),
        super(
          details: NodeDetails.byId(
            level: -1,
            id: 'root',
          ),
        );

  /// adjust the depth level of the children
  void redepthChildren({int? currentLevel, bool checkFirst = false}) {
    void redepth(List<Node> unformattedChildren, int currentLevel) {
      for (int i = 0; i < unformattedChildren.length; i++) {
        final Node node = unformattedChildren.elementAt(i);
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
      final childLevel = level + 1;
      for (final child in children) {
        if (child.level != childLevel) {
          ignoreRedepth = true;
          break;
        }
      }
    }
    if (ignoreRedepth) return;

    redepth(children, currentLevel ?? 0);
    notify();
  }

  @override
  Root copyWith({NodeDetails? details, List<Node>? children}) {
    return Root(children: children ?? this.children);
  }

  @override
  Root clone() {
    return Root(
      children: children
          .map(
            (e) => e.clone(),
          )
          .toList(),
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
  static Root? fromJsonTest(Map<String, dynamic> json) {
    if (json['isRoot'] == null) return null;
    return Root.testing(
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
                      // ignore: invalid_use_of_visible_for_testing_member
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
                    // ignore: invalid_use_of_visible_for_testing_member
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
    );
  }

  static Root? fromJson(Map<String, dynamic> json) {
    if (json['isRoot'] == null) return null;
    return Root(
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
                      Folder.fromJson(el as Map<String, dynamic>);
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
                    final Folder? folder = Folder.fromJson(map);
                    return folder!;
                  }
                  throw Exception(
                    'The element $map does not contain knowed '
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
      'details': details.toJson(),
      'children': children
          .map(
            (Node e) => e.toJson(),
          )
          .toList(),
    };
  }

  @override
  int get hashCode => details.hashCode ^ children.hashCode;

  @override
  bool operator ==(covariant Root other) {
    if (identical(this, other)) return true;
    return details == other.details &&
        _equality.equals(
          children,
          other.children,
        );
  }

  @override
  String toString() {
    return 'Root(details: $details, $children)';
  }

  @override
  void dispose() {
    super.dispose();
    for (var e in children) {
      ChangeNotifier.debugAssertNotDisposed(this);
      e.dispose();
    }
  }
}

const ListEquality<Node> _equality = ListEquality();
