import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/interfaces/node_visitor.dart';

@internal
abstract class NodeContainer extends Node {
  final List<Node> _children;

  NodeContainer({
    required List<Node> children,
    required super.details,
  }) : _children = children;

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

  @override
  int countAllNodes({required Predicate countNode}) {
    int count = 0;
    for (int i = 0; i < length; i++) {
      final Node node = elementAt(i);
      if (countNode(node)) {
        count++;
      }
      count += node.countAllNodes(countNode: countNode);
    }
    return count;
  }

  @override
  int countNodes({required Predicate countNode}) {
    int count = 0;
    for (int i = 0; i < length; i++) {
      final Node node = elementAt(i);
      if (countNode(node)) {
        count++;
      }
    }
    return count;
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

  List<Node> get children => _children;

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
}
