import 'dart:convert';

// TODO: document this
class LayoutSettingsIndent {
  final bool applyChanges;
  final bool indentParagraph;
  final bool indentJustAfterFirstParagraph;
  LayoutSettingsIndent({
    required this.applyChanges,
    required this.indentParagraph,
    required this.indentJustAfterFirstParagraph,
  });

  factory LayoutSettingsIndent.common() {
    return LayoutSettingsIndent(
      applyChanges: false,
      indentParagraph: false,
      indentJustAfterFirstParagraph: false,
    );
  }

  LayoutSettingsIndent copyWith({
    bool? applyChanges,
    bool? indentParagraph,
    bool? indentAfterFirst,
  }) {
    return LayoutSettingsIndent(
      applyChanges: applyChanges ?? this.applyChanges,
      indentParagraph: indentParagraph ?? this.indentParagraph,
      indentJustAfterFirstParagraph:
          indentAfterFirst ?? indentJustAfterFirstParagraph,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'applyChanges': applyChanges,
      'indentParagraph': indentParagraph,
      'indentJustAfterFirstParagraph': indentJustAfterFirstParagraph,
    };
  }

  factory LayoutSettingsIndent.fromMap(Map<String, dynamic> map) {
    return LayoutSettingsIndent(
      applyChanges: map['applyChanges'] as bool? ?? false,
      indentParagraph: map['indentParagraph'] as bool? ?? false,
      indentJustAfterFirstParagraph:
          map['indentJustAfterFirstParagraph'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(
        toMap(),
      );

  factory LayoutSettingsIndent.fromJson(String source) =>
      LayoutSettingsIndent.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'LayoutSettingsIndent('
        'applyChanges: $applyChanges, '
        'indentParagraph: $indentParagraph, '
        'indentJustAfterFirstParagraph: $indentJustAfterFirstParagraph'
        ')';
  }

  @override
  bool operator ==(covariant LayoutSettingsIndent other) {
    if (identical(this, other)) return true;

    return other.applyChanges == applyChanges &&
        other.indentParagraph == indentParagraph &&
        other.indentJustAfterFirstParagraph == indentJustAfterFirstParagraph;
  }

  @override
  int get hashCode =>
      applyChanges.hashCode ^
      indentParagraph.hashCode ^
      indentJustAfterFirstParagraph.hashCode;
}
