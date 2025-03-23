import 'package:novident_remake/src/utils/typedefs.dart';

extension MapExtension<K, V> on Map<K, V> {
  Map<K, V>? firstEntryWhere({required MapEntryPredicate<K, V> predicate}) {
    final MapEntry<K, V>? entry = entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .firstOrNull;
    if (entry == null) return null;
    return <K, V>{entry.key: entry.value};
  }

  K? firstKeyWhere({required MapEntryPredicate<K, V> predicate}) {
    final MapEntry<K, V>? entry = entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .firstOrNull;
    if (entry == null) return null;
    return entry.key;
  }

  V? firstValueWhere({required MapEntryPredicate<K, V> predicate}) {
    final MapEntry<K, V>? entry = entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .firstOrNull;
    if (entry == null) return null;
    return entry.value;
  }

  bool updateValueWhere(
      {required MapEntryPredicate<K, V> predicate, required V value}) {
    final MapEntry<K, V>? entry = entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .firstOrNull;
    if (entry == null) return false;
    this[entry.key] = value;
    return this[entry.key] == value;
  }

  Map<K, V>? getNullIfEmpty() {
    return isEmpty ? null : this;
  }

  Map<K, V>? ignoreIf({required MapEntryPredicate<K, V> predicate}) {
    if (isEmpty) return null;
    final Map<K, V> mapHelper = <K, V>{...this}..removeWhere(predicate);
    if (mapHelper.isEmpty) return null;
    return mapHelper;
  }

  Iterable<V>? firstValuesWhere({required MapEntryPredicate<K, V> predicate}) {
    final Iterable<V> entries = this
        .entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .map((MapEntry<K, V> mapEntry) => mapEntry.value);
    if (entries.isEmpty) return null;
    return entries;
  }

  Iterable<Map<K, V>>? firstEntriesWhere(
      {required MapEntryPredicate<K, V> predicate}) {
    final Iterable<Map<K, V>> entries = this
        .entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .map((MapEntry<K, V> e) => <K, V>{e.key: e.value})
        .toList();
    if (entries.isEmpty) return null;
    return entries;
  }

  Iterable<K>? firstKeysWhere({required MapEntryPredicate<K, V> predicate}) {
    final Iterable<K> entries = this
        .entries
        .where((MapEntry<K, V> element) => predicate(
              element.key,
              element.value,
            ))
        .map((MapEntry<K, V> mapEntry) => mapEntry.key);
    if (entries.isEmpty) return null;
    return entries;
  }
}
