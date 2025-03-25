import 'package:flutter/foundation.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart' show Node;
import 'package:novident_remake/src/domain/interfaces/clonable_mixin.dart';
import 'package:novident_remake/src/utils/id_generators.dart';

/// Represents a [NodeDetails] into the tree a make possible
/// identify it into tree and make operations with them
class NodeDetails
    implements Comparable<NodeDetails>, ClonableMixin<NodeDetails> {
  final String id;
  final int level;
  final Object? value;
  Node? _owner;

  NodeDetails({
    required this.level,
    this.value,
    Node? owner,
  })  : _owner = owner,
        id = IdGenerator.gen();

  @visibleForTesting
  NodeDetails.testing({
    required this.level,
    required this.id,
    this.value,
    Node? owner,
  }) : _owner = owner;

  NodeDetails.byId({
    required this.level,
    required this.id,
    this.value,
    Node? owner,
  }) : _owner = owner;

  bool get hasNotOwner => owner == null;
  bool get hasOwner => !hasNotOwner;
  Node? get owner => _owner;
  set owner(Node? node) {
    if (_owner == node) return;
    _owner = node;
  }

  /// Clone this object but with a new level value
  /// by default the level is [0]
  NodeDetails cloneWithNewLevel([int? level]) {
    level ??= 0;
    return copyWith(level: level);
  }

  NodeDetails copyWith({int? level, String? id, Node? owner, Object? value}) {
    return NodeDetails.byId(
      level: level ?? this.level,
      id: id ?? this.id,
      value: value ?? this.value,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'id': id,
      'owner': owner,
      'value': value,
    };
  }

  factory NodeDetails.base([String? id, Node? owner]) {
    return NodeDetails.byId(
      level: 0,
      id: id ?? IdGenerator.gen(version: 4),
      owner: owner,
    );
  }

  factory NodeDetails.withLevel([int? level, Node? owner]) {
    level ??= 0;
    return NodeDetails.byId(
      level: level,
      id: IdGenerator.gen(version: 4),
      owner: owner,
    );
  }

  factory NodeDetails.zero([Node? owner]) {
    return NodeDetails.byId(
      level: 0,
      id: IdGenerator.gen(version: 4),
      owner: owner,
    );
  }

  factory NodeDetails.fromJson(Map<String, dynamic> json) {
    return NodeDetails.byId(
      level: json['level'] as int,
      value: json['value'] as Object?,
      id: json['id'] as String,
      owner: json['owner'] as Node?,
    );
  }

  @override
  String toString() {
    return 'Level: $level, '
        'ID: ${id.substring(0, id.length < 4 ? id.length : 4)}, '
        'value: $value, '
        'Owner: $owner';
  }

  @override
  int compareTo(NodeDetails other) {
    return level < other.level
        ? -1
        : level > other.level
            ? 1
            : 0;
  }

  @override
  int get hashCode =>
      level.hashCode ^ value.hashCode ^ owner.hashCode ^ id.hashCode;

  @override
  bool operator ==(covariant NodeDetails other) {
    if (identical(this, other)) return true;
    return level == other.level &&
        id == other.id &&
        owner == other.owner &&
        value == other.value;
  }

  @override
  NodeDetails clone() {
    return NodeDetails.byId(
      level: level,
      value: value,
      owner: owner,
      id: id,
    );
  }
}
