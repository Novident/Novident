import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/num_extensions.dart';

/// [Tree Structure Representation]       [Section ID Mappings]
///
/// Level 0
/// ├─ 📁 root_folder (folder_0)           Folders: {
/// │  │                                   '0': 'section-id-0',
/// │  └─┬─ Level 1                   ┌──▶ '1': 'section-id-1',
/// │    ├─ 📁 SubFolder (folder_1) ──┘    '2': 'section-id-2'}
/// │    │  │
/// │    │  └─┬─ Level 2
/// │    │    └─ 📁 SubFolder (folder_2)
/// │    │
/// │    └─┬─ Level 1
/// │      └─ 📄 subDoc (doc_1)  ──┐        Documents: {
/// │         │                    └──┐      '0': 'section-id-0',
/// │         └─┬─ Level 2            └─▶    '1': 'section-id-1'}
/// │           │
/// │           └─ 📁 SubFolder (folder_2)
/// │
/// └─ 📄 root_doc (doc_0)
class SectionTypeConfigurations {
  final Map<String, String> outlineFolder;
  final Map<String, String> outlineDocs;

  SectionTypeConfigurations({
    required this.outlineFolder,
    required this.outlineDocs,
  });

  SectionTypeConfigurations.starter()
      : outlineDocs = <String, String>{},
        outlineFolder = <String, String>{};

  /// Updates all section IDs matching a specific value in selected configurations
  ///
  /// [targetValue] - The section ID value to search and replace
  /// [selection] - Which configurations to update (folders, documents, or both)
  void updateMatchingSectionIds(String targetValue, Selection selection) {
    void updateMap(Map<String, String> map) {
      map.updateValueWhere(
        predicate: (key, value) => value == targetValue,
        value: targetValue,
      );
    }

    if (selection == Selection.document || selection == Selection.both) {
      updateMap(outlineDocs);
    }
    if (selection == Selection.folder || selection == Selection.both) {
      updateMap(outlineFolder);
    }
  }

  /// Gets the maximum configured level for a content type
  ///
  /// Returns -1 if no configurations exist for the specified type
  int getMaxLevel(Selection contentType) {
    final Map<String, String> targetMap =
        contentType == Selection.folder ? outlineFolder : outlineDocs;

    if (targetMap.isEmpty) return -1;
    return targetMap.keys.map(int.parse).reduce(max);
  }

  /// Checks if a given level is the maximum configured level for a content type
  bool isMaxLevel(Selection contentType, int level) {
    return getMaxLevel(contentType) == level;
  }

  String? searchByOutline({required Node param, required Selection selection}) {
    if (selection == Selection.document) {
      return outlineDocs.isEmpty
          ? null
          : outlineDocs['${findEffectiveLevel(param.level, outlineDocs)}'];
    }
    return outlineFolder.isEmpty
        ? null
        : outlineFolder['${findEffectiveLevel(param.level, outlineFolder)}'];
  }

  /// Retrieves the appropriate section ID for a given node level and content type
  ///
  /// Automatically falls back to the nearest existing level if requested level
  /// exceeds configured depth. Returns null if no configurations exist.
  ///
  /// Example:
  /// If we search the id of a section from depth level of 5 ->
  ///
  /// ```console
  /// ┌────────────────────│Tree│───────────────────┐
  /// │ → 0 does not match                          │
  /// │ 0: <id-section-1> ↓ 1. it match either      │
  /// │ │→ 1: <id-section-2> ↓ 2. it match either,  │
  /// │ │ │          -         but it's the last    │
  /// │ │ │→ 2: <id-section-3>                      │
  /// └─────────────────────────────────────────────┘
  /// ```
  ///
  /// Then this will return the id from the last level:
  ///
  /// ```console
  /// <id-section-3>
  /// ```
  ///
  /// because there arent more deeper levels and, to duplicate the default
  /// behavior of Scrivener (using the last as the default for other more deep nodes)
  String? getSectionIdForLevel({required Node node, required Selection contentType}) {
    final Map<String, String> targetMap =
        contentType == Selection.folder ? outlineFolder : outlineDocs;

    if (targetMap.isEmpty) return null;

    final int effectiveLevel = findEffectiveLevel(
      node.level,
      targetMap,
    );
    return targetMap['$effectiveLevel'];
  }

  /// Updates the section ID for a specific level and content type
  ///
  /// Throws [ArgumentError] if trying to update a non-existent level
  void updateSectionIdAtLevel({
    required int level,
    required String newSectionId,
    required Selection contentType,
  }) {
    final Map<String, String> targetMap =
        contentType == Selection.folder ? outlineFolder : outlineDocs;

    if (!targetMap.containsKey('$level')) {
      throw ArgumentError('No $contentType configuration exists for level $level');
    }

    targetMap['$level'] = newSectionId;
  }

  /// Insert the section ID and updated automatically internally
  ///
  /// {1: A, 2: B} → {1: A, 2: B} becomes {1: A, 2: C, 3: B}
  void insert(Selection selection, NodeDetails node, String section) {
    if (selection != Selection.none) {
      final bool isFolder = selection == Selection.folder;
      if (node.level <= -1) return;
      final int currentLevel = node.level.nonNegative();

      final Map<String, String> newOutlineState = isFolder
          ? outlineFolder.shiftLevels(currentLevel, section)
          : outlineDocs.shiftLevels(currentLevel, section);

      (isFolder ? outlineFolder : outlineDocs)
        ..clear()
        ..addAll(newOutlineState);
      return;
    }
    final bool isFolder = selection == Selection.folder;
    final Map<String, String> currentLevels = isFolder ? outlineFolder : outlineDocs;

    final String nextLevelKey =
        currentLevels.isEmpty ? '0' : '${getMaxLevel(selection) + 1}';

    final Map<String, String> newLevels = {...currentLevels, nextLevelKey: section};
    (isFolder ? outlineFolder : outlineDocs)
      ..clear()
      ..addAll(newLevels);
  }

  /// Removes a Section ID and updates its internal state 
  ///
  /// If you remove level 2:
  ///        ↓
  /// {1: A, 2: B, 3: C, 4: D} becomes {1: A, 2: C, 3: D}
  void remove(Selection selection, NodeDetails node) {
    final bool isFolder = selection == Selection.folder;
    if (node.level <= -1) return;
    final int currentLevel = node.level.nonNegative();

    final Map<String, String> newOutlineState = isFolder
        ? outlineFolder.unshiftLevels(currentLevel)
        : outlineDocs.unshiftLevels(currentLevel);

    (isFolder ? outlineFolder : outlineDocs)
      ..clear()
      ..addAll(newOutlineState);
  }

  /// Determines the effective level to use based on existing configurations
  ///
  /// If requested level exceeds maximum configured level, returns the highest
  /// existing level. Otherwise returns the requested level.
  int findEffectiveLevel(int requestedLevel, Map<String, String> levelMap) {
    final int maxLevel = levelMap.keys
        .map(int.parse)
        .fold(-1, (prev, current) => current > prev ? current : prev);

    return requestedLevel > maxLevel ? maxLevel : requestedLevel;
  }

  /*int isDeeperThanTheMajorNode(int level, Map<String, String> outline) {
    int majorNodeLevel = 0;
    int length = outline.keys.length;
    for (int i = 0; i < length; i++) {
      int nodeLevel = int.tryParse(outline.keys.elementAt(i))!;
      // verify whether the current node element, is has major thant it and takes the value if it is
      if (majorNodeLevel < nodeLevel) majorNodeLevel = nodeLevel;
    }
    //return the last level to return the section (avoid nulls). This because the last works as the major node and the deeper one to another nodes
    return majorNodeLevel < level ? majorNodeLevel : level;
  }
  */

  SectionTypeConfigurations copyWith({
    Map<String, String>? outlineFolder,
    Map<String, String>? outlineDocs,
  }) {
    return SectionTypeConfigurations(
      outlineFolder: outlineFolder ?? this.outlineFolder,
      outlineDocs: outlineDocs ?? this.outlineDocs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'outlineFolder': outlineFolder,
      'outlineDocs': outlineDocs,
    };
  }

  factory SectionTypeConfigurations.fromMap(Map<String, dynamic> map) {
    return SectionTypeConfigurations(
      outlineFolder:
          Map<String, String>.from((map['outlineFolder'] as Map<String, dynamic>)),
      outlineDocs: Map<String, String>.from((map['outlineDocs'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionTypeConfigurations.fromJson(String source) =>
      SectionTypeConfigurations.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant SectionTypeConfigurations other) {
    if (identical(this, other)) return true;

    return mapEquals(other.outlineFolder, outlineFolder) &&
        mapEquals(other.outlineDocs, outlineDocs);
  }

  @override
  int get hashCode => outlineFolder.hashCode ^ outlineDocs.hashCode;

  @override
  String toString() => 'SectionTypeConfigurations('
      'outlineFolder: $outlineFolder, '
      'outlineDocs: $outlineDocs'
      ')';
}
