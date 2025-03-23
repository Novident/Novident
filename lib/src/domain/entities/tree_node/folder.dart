import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_type_convertion_exception.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_value.dart';
import 'package:novident_remake/src/domain/interfaces/node_visitor.dart';
import 'package:novident_remake/src/domain/logger/tree_logger.dart';

/// [Folder] represents a node that can contains all
/// types of Nodes as its children
///
/// You can take this implementation as a directory from your
/// local storage that can contains a wide variety of file types
final class Folder extends Node
    with NodeVisitor, NodeHasValue<Delta>, NodeHasName {
  final List<Node> _children;
  final FolderType type;
  final NodeTrashedOptions trashOptions;
  final String name;
  final Delta content;

  /// If expanded is true the [Folder]
  /// should show the children into it
  bool _isExpanded;

  Folder({
    required List<Node> children,
    required this.content,
    required this.name,
    required super.details,
    this.type = FolderType.normal,
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
    bool isExpanded = false,
  })  : _children = children,
        _isExpanded = isExpanded {
    for (final Node child in children) {
      child.owner = this;
    }
    redepthChildren(checkFirst: true);
  }

  @visibleForTesting
  Folder.testing({
    required List<Node> children,
    required this.content,
    required this.name,
    required super.details,
    this.type = FolderType.normal,
    this.trashOptions = const NodeTrashedOptions.nonTrashed(),
    bool isExpanded = false,
  })  : _children = children,
        _isExpanded = isExpanded;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool expand) {
    _isExpanded = expand;
    notify();
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

    void redepth(List<Node> unformattedChildren, int currentLevel) {
      currentLevel = level;
      for (int i = 0; i < unformattedChildren.length; i++) {
        final node = unformattedChildren.elementAt(i);
        unformattedChildren[i] = node.copyWith(
          details: node.details.copyWith(level: currentLevel + 1),
        );
        if (node is Folder && node.isNotEmpty) {
          redepth(node._children, currentLevel + 1);
        }
      }
    }

    bool ignoreRedepth = false;
    if (checkFirst) {
      final childLevel = level + 1;
      for (final child in _children) {
        if (child.level != childLevel) {
          ignoreRedepth = true;
          break;
        }
      }
    }
    if (ignoreRedepth) return;

    redepth(_children, currentLevel ?? level);
    notify();
  }

  @override
  Node? visitAllNodes({required Predicate shouldGetNode}) {
    for (int i = 0; i < length; i++) {
      final Node node = elementAt(i);
      if (shouldGetNode(node)) {
        return node;
      }
      final Node? foundedNode =
          node.visitAllNodes(shouldGetNode: shouldGetNode);
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
      children: children ?? _children,
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
      children: _children
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
    for (int i = 0; i < (currentChildren ?? _children).length; i++) {
      final node = (currentChildren ?? _children).elementAt(i);
      if (predicate(node)) {
        return true;
      } else if (node is Folder && node.isNotEmpty) {
        final foundedNode = existNodeWhere(predicate, node._children);
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

  List<Node> get children => List<Node>.from(_children);

  Node get first => _children.first;

  Node get last => _children.last;

  Node? get lastOrNull => _children.lastOrNull;

  Node? get firstOrNull => _children.firstOrNull;

  Iterator<Node> get iterator => _children.iterator;

  Iterable<Node> get reversed => _children.reversed;

  bool get isEmpty => _children.isEmpty;

  bool get hasNoChildren => _children.isEmpty;

  bool get isNotEmpty => !isEmpty;

  int get length => _children.length;

  Node elementAt(int index) {
    return _children.elementAt(index);
  }

  Node? elementAtOrNull(int index) {
    return _children.elementAtOrNull(index);
  }

  bool contains(Object object) {
    return _children.contains(object);
  }

  void clearAndOverrideState(List<Node> newChildren) {
    clear();
    addAll(newChildren);
  }

  int indexWhere(bool Function(Node) callback) {
    return _children.indexWhere(callback);
  }

  int indexOf(Node element, int start) {
    return _children.indexOf(element, start);
  }

  Node firstWhere(bool Function(Node) callback) {
    return _children.firstWhere(callback);
  }

  Node lastWhere(bool Function(Node) callback) {
    return _children.lastWhere(callback);
  }

  void add(Node element) {
    if (element.owner != this) {
      element.owner = this;
    }
    _children.add(element);
    notify();
  }

  void addAll(Iterable<Node> children) {
    for (final Node child in children) {
      if (child.owner != this) {
        child.owner = this;
      }
      _children.add(child);
    }
    notify();
  }

  void insert(int index, Node element) {
    if (element.owner != this) {
      element.owner = this;
    }
    _children.insert(index, element);
    notify();
  }

  void clear() {
    _children.clear();
    notify();
  }

  bool remove(Node element) {
    final removed = _children.remove(element);
    notify();
    return removed;
  }

  Node removeLast() {
    final Node value = _children.removeLast();
    notify();
    return value;
  }

  void removeWhere(bool Function(Node) callback) {
    _children.removeWhere(callback);
    notify();
  }

  Node removeAt(int index) {
    final Node value = _children.removeAt(index);
    notify();
    return value;
  }

  void operator []=(int index, Node newNodeState) {
    if (index < 0) return;
    if (newNodeState.owner != this) {
      newNodeState.owner = this;
    }
    _children[index] = newNodeState;
    notify();
  }

  Node operator [](int index) {
    return _children[index];
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
      'children': _children
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
    for (var e in _children) {
      ChangeNotifier.debugAssertNotDisposed(this);
      e.dispose();
    }
  }

  @override
  int get hashCode =>
      details.hashCode ^
      isExpanded.hashCode ^
      _children.hashCode ^
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
          _children,
          other._children,
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
        'children: $_children'
        ')';
  }
}

const ListEquality<Node> _equality = ListEquality();
