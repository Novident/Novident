import 'dart:convert';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/layout/helpers/build_delta_part.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart'
    show SectionAttributes;
import 'package:novident_remake/src/domain/entities/layout/options/title_options.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';

@immutable
class LayoutSectionManager extends Equatable {
  final LayoutSection titleSection;
  final LayoutSection metadataSection;
  final LayoutSection synopsisSection;
  final LayoutSection notesSection;
  final LayoutSection textSection;
  const LayoutSectionManager({
    required this.titleSection,
    required this.metadataSection,
    required this.synopsisSection,
    required this.notesSection,
    required this.textSection,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titleSection': titleSection.toMap(),
      'metadataSection': metadataSection.toMap(),
      'synopsisSection': synopsisSection.toMap(),
      'notesSection': notesSection.toMap(),
      'textSection': textSection.toMap(),
    };
  }

  factory LayoutSectionManager.fromMap(Map<String, dynamic> map) {
    return LayoutSectionManager(
      titleSection: LayoutSection.fromMap(map['titleSection'] as Map<String, dynamic>),
      metadataSection:
          LayoutSection.fromMap(map['metadataSection'] as Map<String, dynamic>),
      synopsisSection:
          LayoutSection.fromMap(map['synopsisSection'] as Map<String, dynamic>),
      notesSection: LayoutSection.fromMap(map['notesSection'] as Map<String, dynamic>),
      textSection: LayoutSection.fromMap(map['textSection'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LayoutSectionManager.fromJson(String source) =>
      LayoutSectionManager.fromMap(json.decode(source) as Map<String, dynamic>);

  LayoutSectionManager copyWith({
    LayoutSection? titleSection,
    LayoutSection? metadataSection,
    LayoutSection? synopsisSection,
    LayoutSection? notesSection,
    LayoutSection? textSection,
  }) {
    return LayoutSectionManager(
      titleSection: titleSection ?? this.titleSection,
      metadataSection: metadataSection ?? this.metadataSection,
      synopsisSection: synopsisSection ?? this.synopsisSection,
      notesSection: notesSection ?? this.notesSection,
      textSection: textSection ?? this.textSection,
    );
  }

  @override
  List<Object> get props {
    return <Object>[
      titleSection,
      metadataSection,
      synopsisSection,
      notesSection,
      textSection,
    ];
  }

  @override
  bool get stringify => true;
}

@immutable
class LayoutSection extends Equatable {
  final bool show;
  final bool overrideTextSection;
  final bool overrideAlign;
  final String title;
  final SectionAttributes attributes;
  const LayoutSection({
    required this.show,
    required this.title,
    required this.attributes,
    this.overrideTextSection = false,
    this.overrideAlign = false,
  });

  LayoutSection copyWith({
    bool? show,
    bool? overrideTextSection,
    bool? overrideAlign,
    String? title,
    SectionAttributes? attributes,
  }) {
    return LayoutSection(
      show: show ?? this.show,
      overrideAlign: overrideAlign ?? this.overrideAlign,
      overrideTextSection: overrideTextSection ?? this.overrideTextSection,
      title: title ?? this.title,
      attributes: attributes ?? this.attributes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'show': show,
      'override_align': overrideAlign,
      'override_txt_section': overrideTextSection,
      'title': title,
      'attributes': attributes.toMap(),
    };
  }

  factory LayoutSection.fromMap(Map<String, dynamic> map) {
    return LayoutSection(
      show: map['show'] as bool,
      overrideAlign: map['override_align'] as bool? ?? false,
      overrideTextSection: map['override_txt_section'] as bool? ?? false,
      title: map['title'] as String,
      attributes: SectionAttributes.fromMap(
        map['attributes'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LayoutSection.fromJson(String source) => LayoutSection.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object> get props {
    return [
      show,
      overrideTextSection,
      overrideAlign,
      title,
      attributes,
    ];
  }

  @internal
  Delta? buildDelta({
    required TitleOptions options,
    required CompilerContext context,
    required bool assignFamilyBySection,
    required bool ignorePreffixSuffix,
    required String fontFamily,
    required String? content,
  }) {
    final Delta delta = Delta();
    final Map<String, dynamic>? blockAttributes = attributes
        .toQuillMap(
          inline: false,
        )
        .getNullIfEmpty();
    final Map<String, dynamic>? inlineAttributes = attributes
        .toQuillMap(
          inline: true,
        )
        .getNullIfEmpty();
    // assignFamilyBySection ? attributes.fontFamily : fontFamily,
    _InsertBlocksPosition insertBlocksAt = _InsertBlocksPosition.afterSuffix;
    if (options.titleSuffix.hasNewLineAtStart &&
        (content?.isNotEmpty ?? false) &&
        !ignorePreffixSuffix) {
      insertBlocksAt = _InsertBlocksPosition.beforeSuffix;
    }

    if (!ignorePreffixSuffix) {
      buildDeltaPart(options.buildPrefix(), context).operations.forEach(
            delta.push,
          );
    }
    if (show && content != null && content.isNotEmpty) {
      delta.insert(content, inlineAttributes);
      if (blockAttributes != null &&
          blockAttributes.isNotEmpty &&
          insertBlocksAt == _InsertBlocksPosition.beforeSuffix) {
        delta.insert('\n', blockAttributes);
      }
    }
    if (!ignorePreffixSuffix) {
      buildDeltaPart(options.buildSuffix(), context).operations.forEach(
            delta.push,
          );
    }
    if (blockAttributes != null &&
        blockAttributes.isNotEmpty &&
        insertBlocksAt == _InsertBlocksPosition.afterSuffix &&
        delta.isNotEmpty) {
      delta.insert('\n', blockAttributes);
    }
    return delta;
  }
}

enum _InsertBlocksPosition {
  afterSuffix,
  beforeSuffix,
}
