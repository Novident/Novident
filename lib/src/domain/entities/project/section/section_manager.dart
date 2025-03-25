import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:novident_remake/src/domain/entities/project/section/section.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';

class SectionManager {
  final List<Section> sections;
  final SectionTypeConfigurations config;

  SectionManager({
    required this.sections,
    required this.config,
  });

  int get length => sections.length;

  Section? where(bool Function(Section element) onFound) {
    return sections.firstWhereOrNull(onFound);
  }

  void insertAt(Section object, int index) {
    sections.insert(index, object);
  }

  void removeAt(int index) {
    sections.removeAt(index);
  }

  Section elementAt(int index) {
    RangeError.checkNotNegative(index, "index");
    Iterator<Section> iterator = sections.iterator;
    int skipCount = index;
    while (iterator.moveNext()) {
      if (skipCount == 0) return iterator.current;
      skipCount--;
    }
    throw IndexError.withLength(index, index - skipCount,
        indexable: this, name: "index");
  }

  Section? elementAtOrNull(int index) {
    if (index >= sections.length || index < 0) return null;
    return sections.elementAtOrNull(index);
  }

  SectionManager copyWith({
    List<Section>? sections,
    SectionTypeConfigurations? config,
  }) {
    return SectionManager(
      sections: sections ?? this.sections,
      config: config ?? this.config,
    );
  }

  factory SectionManager.fromMap(Map<String, dynamic> map) {
    return SectionManager(
      sections: List<Section>.from(
        (map['sections'] as List).map<Section>(
          (x) => Section.fromMap(x as Map<String, dynamic>),
        ),
      ),
      config: SectionTypeConfigurations.fromMap(
          map['config'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sections': sections.map((Section x) => x.toMap()).toList(),
      'config': config.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory SectionManager.fromJson(String source) =>
      SectionManager.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant SectionManager other) {
    if (identical(this, other)) return true;

    return config == other.config && listEquals(other.sections, sections);
  }

  @override
  int get hashCode => sections.hashCode ^ config.hashCode;

  @override
  String toString() => 'SectionManager(sections: $sections, config: $config)';
}
