import 'package:meta/meta.dart';
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

  bool updateValueWhere({required MapEntryPredicate<K, V> predicate, required V value}) {
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

  Iterable<Map<K, V>>? firstEntriesWhere({required MapEntryPredicate<K, V> predicate}) {
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

@internal
extension ShiftLevelsMapExtension on Map<String, String> {
  Map<String, String> shiftLevels(int insertionLevel, String value) {
    final List<MapEntry<String, String>> entries = this.entries.toList();
    final Map<String, String> newLevels = <String, String>{};
    bool shouldShift = false;

    for (final MapEntry<String, String> entry in entries) {
      final level = int.parse(entry.key);

      if (level == insertionLevel) {
        newLevels['$level'] = entry.value;
        newLevels['${level + 1}'] = value;
        shouldShift = true;
        continue;
      }

      final String newKey = shouldShift ? '${level + 1}' : entry.key;
      newLevels[newKey] = entry.value;
    }

    return newLevels;
  }

  Map<String, String> unshiftLevels(
    int removalLevel,
  ) {
    final List<MapEntry<String, String>> entries = this.entries.toList();
    final Map<String, String> newLevels = <String, String>{};
    bool shouldAdjust = false;

    // order every entry by its level 
    entries.sort(
      (MapEntry<String, String> a, MapEntry<String, String> b) => int.parse(a.key).compareTo(
        int.parse(b.key),
      ),
    );

    for (final MapEntry<String, String> entry in entries) {
      final int currentLevel = int.parse(entry.key);

      // ignores this element 
      if (currentLevel == removalLevel) {
        shouldAdjust = true;
        continue;
      }

      // adjust elements after the deleted item level 
      final int newLevel = shouldAdjust ? currentLevel - 1 : currentLevel;

      // checks if the adjust that we made is correct 
      if (shouldAdjust &&
          newLevel != (int.parse(newLevels.keys.lastOrNull ?? '-1') + 1)) {
        throw StateError('Niveles inconsistentes después de eliminar $removalLevel');
      }

      newLevels['$newLevel'] = entry.value;
    }

    return newLevels;
  }
}
