import 'package:novident_nodes/novident_nodes.dart';

@Deprecated('Since this cannot fill most of the '
    'requirements that we need. It\'s deprecated '
    'and will be removed soon')
// ignore: unused_element
typedef _ReplacementsValues = Map<String, dynamic>;

typedef MapEntryPredicate<K, V> = bool Function(K key, V value);

typedef Predicate = bool Function(Node node);
typedef ConditionalPredicate<T> = bool Function(T data);
