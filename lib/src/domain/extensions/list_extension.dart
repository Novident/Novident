import 'package:novident_nodes/novident_nodes.dart';

extension ListExtension<T> on List<T> {
  void merge(List<List<T>> listToAdd) {
    int i = 0;
    while (i < listToAdd.length) {
      addAll(listToAdd.elementAt(i));
      i++;
    }
  }

  List<T> updateWhere(
      {required T data, required ConditionalPredicate<T> predicate}) {
    final List<T> temp = <T>[...this];
    for (int i = 0; i < temp.length; i++) {
      final T currentData = temp.elementAt(i);
      if (predicate(currentData)) {
        temp[i] = data;
      }
    }
    return <T>[...temp];
  }

  List<T> ignoreWhile({required ConditionalPredicate<T> ignoreIf}) {
    List<T> cache = <T>[];
    for (int i = 0; i < length; i++) {
      final T element = elementAt(i);
      if (ignoreIf(element)) continue;
      cache.add(element);
    }
    return cache;
  }

  /// Count the all the elements that satifies the predicate
  int count(T obj, {ConditionalPredicate<T>? predicate}) {
    int count = 0, i = 0;
    while (i < length) {
      final T found = elementAt(i);
      if (found == obj) {
        count++;
      } else if (predicate != null && predicate(found)) {
        count++;
      }
      i++;
    }
    return count;
  }

  bool exist({required ConditionalPredicate<T> predicate}) {
    for (T value in this) {
      if (predicate(value)) {
        return true;
      }
    }
    return where((T element) {
          return predicate(element);
        }).firstOrNull !=
        null;
  }
}
