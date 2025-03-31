import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/format/replacement_values.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/enums/project_format_scope.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/utils/id_generators.dart';

@immutable
class Format extends Equatable {
  /// This id is unique and can be modified or used as well as we need it
  final String id;

  /// This reference the id from the project and is automatically passed just when the format is saved as global
  final int? originalProject;
  // Could by by-layout that means the font family
  // will be assigned by the layout instead Format
  final String fontFamily;
  final String name;
  //final PageFormat pageFormat;
  final ReplacementsValues replacements;
  final FormatScope scope;
  final List<Layout> layouts;
  final bool canChange;

  const Format({
    required this.id,
    required this.name,
    required this.fontFamily,
    required this.layouts,
    required this.canChange,
    required this.replacements,
    // required this.pageFormat,
    required this.scope,
    this.originalProject,
  });

  Format.empty({
    this.canChange = true,
    this.name = '',
    FormatScope? scope,
  })  : id = IdGenerator.gen(version: 4),
        replacements = ReplacementsValues(replacements: <Replacement>{}),
        scope = scope ?? FormatScope.project,
        //pageFormat: PageFormat.a4,
        fontFamily = Constant.kDefaultFormatFontFamily,
        layouts = const <Layout>[],
        originalProject = null;

  Format copyWith({
    int? originalProject,
    bool setToNullOriginalProject = false,
    String? id,
    String? name,
    String? fontFamily,
    FormatScope? scope,
    //PageFormat? pageFormat,
    bool? canChange,
    ReplacementsValues? replacements,
    List<Layout>? layouts,
  }) {
    return Format(
      id: id ?? this.id,
      scope: scope ?? this.scope,
      //pageFormat: pageFormat ?? this.pageFormat,
      originalProject: setToNullOriginalProject
          ? null
          : originalProject ?? this.originalProject,
      name: name ?? this.name,
      canChange: canChange ?? this.canChange,
      replacements: replacements ?? this.replacements,
      fontFamily: fontFamily ?? this.fontFamily,
      layouts: layouts ?? this.layouts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'originalProject': originalProject,
      'name': name,
      //'pageFormat': pageFormat.toMap(),
      'can_change': canChange,
      'replacements': replacements,
      'scope': scope.index,
      'family': fontFamily,
      'layouts': jsonEncode(layouts.map((Layout x) => x.toMap()).toList()),
    };
  }

  factory Format.fromMap(Map<String, dynamic> map) {
    return Format(
      id: map['id'] as String? ?? '',
      scope: FormatScope.values[map['scope'] as int? ?? 3],
      name: map['name'] as String,
      originalProject: map['originalProject'] as int?,
      // pageFormat: map['pageFormat'] != null
      //     ? PageFormat.fromMap(map['pageFormat'])
      //     : PageFormat.a4,
      fontFamily: map['family'] as String,
      replacements: map['replacements'] as ReplacementsValues,
      canChange: map['can_change'] as bool? ?? false,
      layouts: List<Layout>.from(
        (jsonDecode(map['layouts'] as String) as List<dynamic>).map<Layout>(
          (dynamic x) => Layout.fromMap(
            x as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Format.fromJson(String source) =>
      Format.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Format(id: $id, '
      //'page-format: $pageFormat, '
      'canChange: $canChange, '
      'replacements: $replacements, '
      'name: $name, '
      'font-family: $fontFamily, '
      'layouts: ${layouts.length}'
      ')';

  Layout? getLayoutWhere({required ConditionalPredicate<Layout> predicate}) {
    return layouts.firstWhereOrNull(predicate);
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        id,
        layouts,
        replacements,
        fontFamily,
        canChange,
        //pageFormat,
        scope,
        originalProject,
      ];

  Future<Format> duplicate(FormatScope scope, [bool? canChange]) async {
    final List<Layout> tempLayouts = <Layout>[];
    for (Layout layout in layouts) {
      tempLayouts.add(layout.copyWith(id: IdGenerator.gen(version: 7)));
    }
    return copyWith(
      canChange: canChange ?? true,
      name: '$name (copy)',
      layouts: tempLayouts,
      originalProject: originalProject,
      fontFamily: fontFamily,
      //pageFormat: pageFormat,
      replacements: replacements,
      id: IdGenerator.gen(version: 4),
      scope: scope,
    );
  }

  bool notAssignedSectionToLayouts() {
    return layouts
        .where(
          (Layout element) => element.assignedSection.isNotEmpty,
        )
        .isEmpty;
  }
}
