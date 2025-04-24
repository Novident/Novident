import 'dart:convert';

class ProjectMetadata {
  final String projectTitle;
  final String abbreviateTitle;
  final String isbncode;
  final String subject;
  final String company;
  final String copyright;
  final String keywords;
  final String comments;

  ProjectMetadata({
    required this.projectTitle,
    required this.abbreviateTitle,
    required this.isbncode,
    required this.subject,
    required this.company,
    required this.copyright,
    required this.keywords,
    required this.comments,
  });

  factory ProjectMetadata.basic() {
    return ProjectMetadata(
      projectTitle: '', //<$projecttitle>
      abbreviateTitle: '', //<$abbr_title>
      isbncode: '', // <$iscode>
      //default metadata for PDF, LaTeX, and Epub books
      subject: '',
      company: '',
      copyright: '',
      keywords: '',
      comments: '',
    );
  }

  ProjectMetadata copyWith({
    String? projectTitle,
    String? abbreviateTitle,
    String? isbncode,
    String? surname,
    String? forename,
    String? subject,
    String? company,
    String? copyright,
    String? keywords,
    String? comments,
  }) {
    return ProjectMetadata(
      projectTitle: projectTitle ?? this.projectTitle,
      abbreviateTitle: abbreviateTitle ?? this.abbreviateTitle,
      isbncode: isbncode ?? this.isbncode,
      subject: subject ?? this.subject,
      company: company ?? this.company,
      copyright: copyright ?? this.copyright,
      keywords: keywords ?? this.keywords,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectTitle': projectTitle,
      'abbreviateTitle': abbreviateTitle,
      'isbncode': isbncode,
      'subject': subject,
      'company': company,
      'copyright': copyright,
      'keywords': keywords,
      'comments': comments,
    };
  }

  factory ProjectMetadata.fromMap(Map<String, dynamic> map) {
    return ProjectMetadata(
      projectTitle: map['projectTitle'] as String,
      abbreviateTitle: map['abbreviateTitle'] as String,
      isbncode: map['isbncode'] as String? ?? '',
      subject: map['subject'] as String,
      company: map['company'] as String,
      copyright: map['copyright'] as String,
      keywords: map['keywords'] as String,
      comments: map['comments'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectMetadata.fromJson(String source) =>
      ProjectMetadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectMetadata('
        'projectTitle: $projectTitle, '
        'abbreviateTitle: $abbreviateTitle, '
        'isbncode: $isbncode, '
        'subject: $subject, '
        'company: $company, '
        'copyright: $copyright, '
        'keywords: $keywords, '
        'comments: $comments'
        ')';
  }

  @override
  bool operator ==(covariant ProjectMetadata other) {
    if (identical(this, other)) return true;

    return other.projectTitle == projectTitle &&
        other.abbreviateTitle == abbreviateTitle &&
        other.isbncode == isbncode &&
        other.subject == subject &&
        other.company == company &&
        other.copyright == copyright &&
        other.keywords == keywords &&
        other.comments == comments;
  }

  @override
  int get hashCode {
    return projectTitle.hashCode ^
        abbreviateTitle.hashCode ^
        isbncode.hashCode ^
        subject.hashCode ^
        company.hashCode ^
        copyright.hashCode ^
        keywords.hashCode ^
        comments.hashCode;
  }
}
