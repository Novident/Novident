import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/node/node_notifier.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/clonable_mixin.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_visitor.dart';

abstract class Node extends NodeNotifier with NodeVisitor, ClonableMixin<Node> {
  final NodeDetails details;
  final LayerLink layer;

  Node({required this.details}) : layer = LayerLink();

  void notify() {
    notifyListeners();
  }

  /// Jump to the upper parent of this node
  @mustCallSuper
  Node? jumpToParent({bool Function(Node node)? stopAt}) {
    if (parent == null || (stopAt?.call(this) ?? false) || this is Root) {
      return this;
    }
    return parent!.jumpToParent();
  }

  @mustCallSuper
  Node? get parent => details.owner;

  @mustCallSuper
  String get id => details.id;

  @mustCallSuper
  int get level => details.level;

  bool get atRoot => level == 0;

  @mustCallSuper
  Node? get owner => details.owner;

  set owner(Node? node) {
    if (details.owner == node) return;
    details.owner = node;
    notify();
  }

  @mustBeOverridden
  Node copyWith({NodeDetails? details});

  @override
  @mustBeOverridden
  bool operator ==(covariant Node other);

  @override
  @mustBeOverridden
  int get hashCode;

  @override
  String toString() {
    return 'Node(details: $details)';
  }

  Map<String, dynamic> toJson();
}
