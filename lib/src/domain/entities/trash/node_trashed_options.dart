import 'package:novident_nodes/novident_nodes.dart';

class NodeTrashedOptions implements ClonableMixin<NodeTrashedOptions> {
  final bool isTrashed;

  /// The time where was converted to a trashed file
  final DateTime? at;

  /// The time where should be removed this file
  final DateTime? end;

  const NodeTrashedOptions({
    required this.isTrashed,
    required this.at,
    required this.end,
  });

  const NodeTrashedOptions.nonTrashed()
      : isTrashed = false,
        at = null,
        end = null;

  NodeTrashedOptions.now({this.end})
      : isTrashed = true,
        at = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'trashed': isTrashed,
      'at': at?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
    };
  }

  factory NodeTrashedOptions.fromJson(Map<String, dynamic> json) {
    return NodeTrashedOptions(
      isTrashed: json['trashed'] as bool,
      at: json['at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
      end: json['end'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
    );
  }

  @override
  bool operator ==(covariant NodeTrashedOptions other) {
    if (identical(this, other)) return true;
    return isTrashed == other.isTrashed && at == other.at && end == other.end;
  }

  @override
  int get hashCode => isTrashed.hashCode ^ at.hashCode ^ end.hashCode;

  @override
  NodeTrashedOptions clone({bool deep = true}) {
    return NodeTrashedOptions(
      isTrashed: isTrashed,
      at: at,
      end: end,
    );
  }

  @override
  String toString() {
    return 'NodeTrashedOptions(trashed: $isTrashed, at: $at, end: $end)';
  }
}
