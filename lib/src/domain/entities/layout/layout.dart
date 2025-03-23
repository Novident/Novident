import 'dart:convert';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/editor_defaults.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/layout/options/layout_indents.dart';
import 'package:novident_remake/src/domain/entities/layout/options/layout_manager.dart';
import 'package:novident_remake/src/domain/entities/layout/options/new_page_options.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_separators_options.dart';
import 'package:novident_remake/src/domain/entities/layout/options/title_options.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart'
    show Document;
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/extensions/map_extensions.dart';
import 'package:novident_remake/src/domain/extensions/project_delta_content_extension.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_value.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';
import 'package:novident_remake/src/utils/id_generators.dart';

/// Layouts provide centralized control over document presentation by defining
/// formatting rules for different content sections (title, metadata, synopsis, etc.).
/// When applied to documents, these layouts automatically enforce consistent styling
/// without manual formatting effort.
///
/// Key features:
/// - Preconfigured section visibility and styling
/// - Automatic Delta generation for Quill-based editors
/// - Serialization/deserialization support
/// - Immutable design with copy-with functionality
/// - Section-specific formatting overrides
@immutable
final class Layout extends Equatable {
  /// Unique identifier for the layout
  final String id;

  /// Human-readable layout name
  final String name;

  /// ID of the associated section (empty if unassigned)
  final String assignedSection;

  /// Central manager for section configurations
  final LayoutSectionManager layoutManager;

  /// Title display and formatting options
  late final TitleOptions titleOptions;

  /// Page break and spacing controls
  late final NewPageOptions newPageOptions;

  /// Section separation rules
  late final SeparatorOptions separatorSections;

  /// Indentation and spacing settings
  late final LayoutSettingsIndent settings;

  /// Creates a Layout with customizable sections and formatting
  ///
  /// [id]: Unique identifier (auto-generated if not provided)
  /// [name]: Layout display name
  /// [layoutManager]: Section configuration manager
  /// [assignedSection]: Associated section ID
  /// [separatorSections]: Section separation rules (defaults to common)
  /// [titleOptions]: Title formatting (defaults to common)
  /// [newPageOptions]: Page break rules (defaults to common)
  /// [settings]: Indentation settings (defaults to common)
  Layout({
    required this.id,
    required this.name,
    required this.layoutManager,
    this.assignedSection = "",
    SeparatorOptions? separatorSections,
    TitleOptions? titleOptions,
    NewPageOptions? newPageOptions,
    LayoutSettingsIndent? settings,
  }) {
    this.settings = settings ?? LayoutSettingsIndent.common();
    this.separatorSections = separatorSections ?? SeparatorOptions.common();
    this.titleOptions = titleOptions ?? TitleOptions.common();
    this.newPageOptions = newPageOptions ?? NewPageOptions.common();
  }

  /// Factory constructor for creating layouts with granular control
  ///
  /// Provides simplified parameterization for common use cases:
  /// - [shareThisAttributesToAll]: Applies same attributes to all sections
  /// - [titleAlign]/[fontSize]: Title-specific formatting
  /// - [show...] parameters: Section visibility toggles
  /// - [textLineSpacing]: Body text spacing
  /// - Attribute overrides for individual sections
  factory Layout.basic({
    String? id,
    String? name,
    String? assigned,
    String? titleAlign,
    double? fontSize,
    bool? boldTitle,
    bool? underlineTitle,
    bool? showTitle,
    bool? showMetadata,
    bool? showSynopsis,
    bool? showNotes,
    bool? showText,
    double? titleLineSpacing,
    double? textLineSpacing,
    TitleOptions? titleOptions,
    NewPageOptions? newPageOptions,
    SeparatorOptions? separatorOptions,
    LayoutSettingsIndent? settings,
    SectionAttributes? shareThisAttributesToAll,
    SectionAttributes? titleAttr,
    SectionAttributes? metaAttr,
    SectionAttributes? textAttr,
    SectionAttributes? synopsisAttr,
    SectionAttributes? notesAttr,
  }) =>
      Layout(
        id: id ?? IdGenerator.gen(version: 7),
        titleOptions: titleOptions,
        separatorSections: separatorOptions,
        settings: settings,
        newPageOptions: newPageOptions,
        assignedSection: assigned ?? "",
        name: name ?? ProjectDefaults.kDefaultUnnamedLayout,
        layoutManager: LayoutSectionManager(
          titleSection: LayoutSection(
            show: showTitle ?? false,
            title: 'Section title',
            attributes: shareThisAttributesToAll != null
                ? shareThisAttributesToAll.copyWith(
                    align: titleAlign,
                    lineHeight: titleLineSpacing,
                    bold: boldTitle ?? false,
                    underline: underlineTitle ?? false,
                    fontSize: fontSize ?? 16,
                  )
                : titleAttr ??
                    SectionAttributes.common(
                      lineHeight: titleLineSpacing,
                      align: titleAlign ?? "left",
                      bold: boldTitle ?? false,
                      underline: underlineTitle ?? false,
                      automaticIndent: false,
                      fontSize: fontSize ?? 16,
                    ),
          ),
          metadataSection: LayoutSection(
            show: showMetadata ?? false,
            title: 'Metadata',
            attributes: shareThisAttributesToAll ??
                metaAttr ??
                SectionAttributes.common(
                    align: "left",
                    fontSize: 12,
                    automaticIndent: false,
                    bold: false),
          ),
          synopsisSection: LayoutSection(
            show: showSynopsis ?? false,
            title: 'Synopsis',
            attributes: shareThisAttributesToAll ??
                synopsisAttr ??
                SectionAttributes.common(
                    align: "left",
                    fontSize: 12,
                    automaticIndent: false,
                    bold: false),
          ),
          notesSection: LayoutSection(
            show: showNotes ?? false,
            title: 'Notes',
            attributes: shareThisAttributesToAll ??
                notesAttr ??
                SectionAttributes.common(
                    align: "left",
                    fontSize: 12,
                    automaticIndent: false,
                    bold: false),
          ),
          textSection: LayoutSection(
            show: showText ?? true,
            overrideTextSection: false,
            overrideAlign: false,
            title: '',
            attributes: shareThisAttributesToAll != null
                ? shareThisAttributesToAll.copyWith(
                    lineHeight: textLineSpacing ?? 1.0,
                    fontSize: 12,
                    align: 'left',
                  )
                : textAttr ??
                    SectionAttributes.common(
                      lineHeight: textLineSpacing ?? 1.0,
                      align: "left",
                      fontSize: 12,
                      automaticIndent: false,
                    ),
          ),
        ),
      );

  Layout copyWith({
    String? id,
    String? name,
    String? assignedSection,
    LayoutSectionManager? layoutManager,
    LayoutSettingsIndent? settings,
    TitleOptions? titleOptions,
    SeparatorOptions? separatorSections,
    NewPageOptions? newPageOptions,
  }) {
    return Layout(
      id: id ?? this.id,
      newPageOptions: newPageOptions ?? this.newPageOptions,
      name: name ?? this.name,
      settings: settings ?? this.settings,
      assignedSection: assignedSection ?? this.assignedSection,
      layoutManager: layoutManager ?? this.layoutManager,
      titleOptions: titleOptions ?? this.titleOptions,
      separatorSections: separatorSections ?? this.separatorSections,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'assignedSection': assignedSection,
      'settings': settings.toMap(),
      'layoutManager': layoutManager.toMap(),
      'pageOptions': newPageOptions.toMap(),
      'titleOptions': titleOptions.toMap(),
      'separatorSections': separatorSections.toMap(),
    };
  }

  factory Layout.fromMap(Map<String, dynamic> map) {
    return Layout(
      id: map['id'] as String,
      name: map['name'] as String,
      assignedSection: map['assignedSection'] as String,
      settings: map['settings'] == null
          ? LayoutSettingsIndent.common()
          : LayoutSettingsIndent.fromMap(
              map['settings'] as Map<String, dynamic>),
      newPageOptions: map['pageOptions'] != null
          ? NewPageOptions.fromMap(map['pageOptions'] as Map<String, dynamic>)
          : NewPageOptions.common(),
      layoutManager: LayoutSectionManager.fromMap(
          (map['layoutManager'] as Map<String, dynamic>)),
      titleOptions:
          TitleOptions.fromMap(map['titleOptions'] as Map<String, dynamic>),
      separatorSections: SeparatorOptions.fromMap(
          map['separatorSections'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Layout.fromJson(String source) =>
      Layout.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Applies new page formatting rules
  ///
  /// Returns list of formatting operations for page breaks
  List<Operation> applyNewPageOptions() {
    return newPageOptions.getNewLines();
  }

  /// Generates formatted Delta for document content
  ///
  /// Processes all active sections and applies:
  /// - Font family inheritance
  /// - Section-specific formatting
  /// - Metadata replacements
  /// - Automatic indentation
  ///
  /// [file]: Document node to process
  /// [context]: Compilation context
  /// [fontFamily]: Base font family (can be overridden by sections)
  Delta build(
    Node file,
    CompilerContext context, {
    String fontFamily = EditorDefaults.kDefaultFontFamily,
  }) {
    final Delta delta = Delta();

    ///if font family is ["by-layout"] then layout decide the font family
    bool assignFamilyBySection = false;
    if (fontFamily.equals(Constant.kDefaultFormatFontFamily,
        caseSensitive: false)) {
      fontFamily = "";
      assignFamilyBySection = true;
    }
    Document? doc;
    if (file is Document) doc = file;
    final LayoutSection titleMapped = layoutManager.titleSection;
    final LayoutSection metadataMapped = layoutManager.metadataSection;
    final LayoutSection synopsisMapped = layoutManager.synopsisSection;
    final LayoutSection notesMapped = layoutManager.notesSection;
    final LayoutSection textMapped = layoutManager.textSection;
    final bool showTitle = titleMapped.show;
    final bool showSynopsis = synopsisMapped.show;
    if (context.shouldWritePageOptions &&
        newPageOptions.newLinesCount.value > 0) {
      context.shouldWritePageOptions = false;
      // adds all the new lines before the content
      applyNewPageOptions().forEach(delta.push);
    }

    if (showTitle) {
      final Delta? title = titleMapped.buildDelta(
        options: titleOptions,
        context: context,
        assignFamilyBySection: assignFamilyBySection,
        fontFamily: fontFamily,
        content:
            '${titleOptions.preffix ?? ''}${file.cast<NodeHasName>().nodeName}${titleOptions.suffix ?? ''}',
        ignorePreffixSuffix: false,
      );
      if (title != null && title.isNotEmpty) {
        title.operations.forEach(delta.push);
      }
    }
    //metadata section
    if (metadataMapped.show) {
      throw UnimplementedError('metadata section is not implemented yet');
    }
    //synopsis section
    if (showSynopsis && doc != null && doc.synopsis.isNotEmpty) {
      final Delta? synopsis = titleMapped.buildDelta(
        options: titleOptions,
        context: context,
        assignFamilyBySection: assignFamilyBySection,
        fontFamily: fontFamily,
        content: doc.synopsis,
        ignorePreffixSuffix: true,
      );
      if (synopsis != null && synopsis.isNotEmpty) {
        synopsis.operations.forEach(delta.push);
      }
      delta.insert('\n');
    }
    //notes section
    if (notesMapped.show) {
      // doc != null && doc.notes.description.isNotEmpty) {
      throw UnimplementedError('notes section is not implemented yet');
      /*
      if (showSynopsis) _buffer.write(',$quillDeltaNewLine');
      final String json = replaceFreeCharactersToDelta(doc.notes.description);
      final SectionAttributes notesAttr = notesMapped.attributes;
      _buffer.write(applySectionAttributesToDelta(json.withBrackets, notesAttr));
      _buffer.write(r',{"insert":"\n"}');
      */
    }
    //text section
    if (textMapped.show) {
      if (fontFamily.isEmpty) {
        fontFamily = textMapped.attributes.fontFamily;
      }
      Delta content = file.cast<NodeHasValue<Delta>>().value;
      if (!context.processPlaceholderAtEnd) {
        content = content.replacePlaceholders(context);
      }

      if (textMapped.overrideTextSection) {
        final Map<String, dynamic>? inlineAttributes =
            textMapped.attributes.toQuillMap(inline: true).getNullIfEmpty();
        //fontFamily,
        final Map<String, dynamic>? blockAttributes =
            textMapped.attributes.toQuillMap(inline: false).getNullIfEmpty();
        content = content.overrideAttributes(
          inlineAttributes ?? <String, dynamic>{},
          blockAttributes ?? <String, dynamic>{},
        );
      }
      content.operations.forEach(delta.push);
    }
    return delta;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        assignedSection,
        layoutManager,
        titleOptions,
        newPageOptions,
        separatorSections,
        settings,
      ];
}
