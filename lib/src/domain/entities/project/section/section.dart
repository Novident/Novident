import 'dart:convert';

/// section types provide a way of typifying components of your book; it’s a way
/// of categorising elements of your work. The differentiating features are set
/// within the section layouts, but you need to start with a list of these categories, these
/// section types, before you can go through the process of setting up the
/// format to suit your requirements.
///
/// Section types provide a framework for how items (folders/documents) can be referred to when we start to apply section layouts
/// and fine tune the formatting.
///
/// They give names to the various different types of material that require different formatting when you reach the compile stage.
class Section {
  final String id;
  final String name;
  Section({
    required this.id,
    required this.name,
  });

  Section copyWith({
    String? id,
    String? name,
  }) {
    return Section(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Section(id: $id, name: $name)';

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
