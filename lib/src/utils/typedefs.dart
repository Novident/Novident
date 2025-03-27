import 'package:novident_remake/src/domain/changes/node_change.dart';

@Deprecated('Since this cannot fill most of the '
    'requirements that we need. It\'s deprecated '
    'and will be removed soon')
// ignore: unused_element
typedef _ReplacementsValues = Map<String, dynamic>;

typedef MapEntryPredicate<K, V> = bool Function(K key, V value);

// used only by ProjectCache and Nodes
typedef NodeNotifierChangeCallback = void Function(NodeChange change);
