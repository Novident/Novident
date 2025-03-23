import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/interfaces/node_visitor.dart';

/// [Root] represents the main tree part of the tree, where
/// all the files are being contained
final class Root extends Node with NodeVisitor {
  final List<Node> children;

  Root({
    required this.children,
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
    required this.children,
  })  : assert(
          children.whereType<Root>().isEmpty,
          'Root children cannot '
          'contain any Root node type',
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
        final node = unformattedChildren.elementAt(i);
        unformattedChildren[i] = node.copyWith(
          details: node.details.copyWith(level: currentLevel + 1),
        );
        if (node is Folder && node.isNotEmpty) {
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
  Node? visitAllNodes({required Predicate shouldGetNode}) {
    for (int i = 0; i < length; i++) {
      final Node node = elementAt(i);
      if (shouldGetNode(node)) {
        return node;
      }
      final Node? foundedNode = node.visitAllNodes(shouldGetNode: shouldGetNode);
      if (foundedNode != null) return foundedNode;
    }
    return null;
  }

  @override
  Node? visitNode({required Predicate shouldGetNode}) {
    for (int i = 0; i < length; i++) {
      final Node node = elementAt(i);
      if (shouldGetNode(node)) {
        return node;
      }
    }
    return null;
  }

  /// Check if the id of the node exist in the root
  /// of the [Folder] without checking into its children
  @override
  bool exist(String nodeId) {
    for (int i = 0; i < length; i++) {
      if (elementAt(i).details.id == nodeId) return true;
    }
    return false;
  }

  /// Check if the id of the node exist into the [Folder]
  /// checking in its children without limitations
  ///
  /// This opertion could be heavy based on the deep of the nodes
  /// into the [Folder]
  @override
  bool deepExist(String nodeId) {
    for (int i = 0; i < length; i++) {
      final node = elementAt(i);
      if (node.details.id == nodeId) {
        return true;
      }
      final foundedNode = node.deepExist(nodeId);
      if (foundedNode) return true;
    }
    return false;
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
  bool existNodeWhere(bool Function(Node node) predicate, [List<Node>? subChildren]) {
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

  Node? childBeforeThis(NodeDetails node, bool alsoInChildren, [int? indexNode]) {
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
        final backNode = treeNode.childBeforeThis(node, alsoInChildren, indexNode);
        if (backNode != null) return backNode;
      }
    }
    return null;
  }

  Node? childAfterThis(NodeDetails node, bool alsoInChildren, [int? indexNode]) {
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
        final nextChild = treeNode.childAfterThis(node, alsoInChildren, indexNode);
        if (nextChild != null) return nextChild;
      }
    }
    return null;
  }

  Node elementAt(int index) {
    return children.elementAt(index);
  }

  Node? elementAtOrNull(int index) {
    return children.elementAtOrNull(index);
  }

  bool contains(Object object) {
    return children.contains(object);
  }

  void clearAndOverrideState(List<Node> newChildren) {
    clear();
    addAll(newChildren);
  }

  Node get first => children.first;
  Node get last => children.last;
  Node? get lastOrNull => children.lastOrNull;
  Node? get firstOrNull => children.firstOrNull;
  Iterator<Node> get iterator => children.iterator;
  Iterable<Node> get reversed => children.reversed;
  bool get isEmpty => children.isEmpty;
  bool get hasNoChildren => children.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get length => children.length;

  int indexWhere(bool Function(Node) callback) {
    return children.indexWhere(callback);
  }

  int indexOf(Node element, int start) {
    return children.indexOf(element, start);
  }

  Node firstWhere(bool Function(Node) callback) {
    return children.firstWhere(callback);
  }

  Node lastWhere(bool Function(Node) callback) {
    return children.lastWhere(callback);
  }

  void add(Node element) {
    if (element.owner != this) {
      element.owner = this;
    }
    children.add(element);
    notify();
  }

  void addAll(Iterable<Node> children) {
    for (final child in children) {
      if (child.owner != this) {
        child.owner = this;
      }
      this.children.add(child);
    }
    notify();
  }

  void insert(int index, Node element) {
    if (element.owner != this) {
      element.owner = this;
    }
    children.insert(index, element);
    notify();
  }

  void clear() {
    children.clear();
    notify();
  }

  bool remove(Node element) {
    final removed = children.remove(element);
    notify();
    return removed;
  }

  Node removeLast() {
    final Node value = children.removeLast();
    notify();
    return value;
  }

  void removeWhere(bool Function(Node) callback) {
    children.removeWhere(callback);
    notify();
  }

  Node removeAt(int index) {
    final Node value = children.removeAt(index);
    notify();
    return value;
  }

  void operator []=(int index, Node newNodeState) {
    if (index < 0) return;
    if (newNodeState.owner != this) {
      newNodeState.owner = this;
    }
    children[index] = newNodeState;
    notify();
  }

  Node operator [](int index) {
    return children[index];
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
            : (jsonDecode(json['children'] as String) as List<String>).map<Node>(
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
                  final Folder? folder = Folder.fromJson(el as Map<String, dynamic>);
                  return folder!;
                }
                throw Exception(
                  'The element $el does not contain knowed '
                  'types supported. Expected Document or Folder types',
                );
              })
            : (jsonDecode(json['children'] as String) as List<String>).map<Node>(
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
