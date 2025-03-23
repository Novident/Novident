import 'dart:convert';

import 'package:novident_remake/src/domain/extensions/num_extensions.dart';
import 'package:novident_remake/src/domain/pattern_defaults.dart';

class Author {
  /// this also can contains several author names
  ///
  /// them must be divided by "," to be detected correctly
  final String name;
  final String stateAndCountry;
  final String street;
  final String city;
  final String zipAndPostCode;
  final String email;
  final String phoneNumber;

  Author({
    this.name = "",
    this.stateAndCountry = "",
    this.street = "",
    this.city = "",
    this.zipAndPostCode = "",
    this.email = "",
    this.phoneNumber = "",
  });

  List<String> getAuthors() {
    if (!name.contains(',')) return <String>[name];
    return name.split(',');
  }

  String getAuthorName(String index) {
    if (index == 'all') return name;
    if (!hasMoreThanFirst) return getAuthorName('1');
    return getAuthors().elementAt(int.parse(index).nonNegativeDecrease());
  }

  String getLastName(String index) {
    if (!hasMoreThanFirst) return getLastName('1');
    if (index == 'all') {
      return getAuthors().map<String>((String author) {
        // if has no spaces, then get the name
        if (author.isEmpty || !author.contains(PatternDefaults.whitespacesPattern)) {
          return author;
        }
        return author
            .split(
              PatternDefaults.whitespacesPattern,
            )
            .elementAt(1);
      }).join(',');
    }
    final String value = getAuthors().elementAt(int.parse(index).nonNegativeDecrease());
    return value.split(PatternDefaults.whitespacesPattern).elementAt(1);
  }

  String getFirstname(String index) {
    if (!hasMoreThanFirst) return getFirstname('1');
    if (index == 'all') {
      return getAuthors().map<String>((String author) {
        // if has no spaces, then get the name
        if (author.isEmpty ||
            !author.contains(
              PatternDefaults.whitespacesPattern,
            )) {
          return author;
        }
        return author
            .split(
              PatternDefaults.whitespacesPattern,
            )
            .first;
      }).join(',');
    }
    return getAuthors()
        .elementAt(int.parse(index).nonNegativeDecrease())
        .split(PatternDefaults.whitespacesPattern)
        .first;
  }

  bool get hasMoreThanFirst => name.contains(',');

  Author copyWith({
    String? name,
    String? stateAndCountry,
    String? street,
    String? city,
    String? zipAndPostCode,
    String? email,
    String? phoneNumber,
  }) {
    return Author(
      name: name ?? this.name,
      stateAndCountry: stateAndCountry ?? this.stateAndCountry,
      street: street ?? this.street,
      city: city ?? this.city,
      zipAndPostCode: zipAndPostCode ?? this.zipAndPostCode,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'stateAndCountry': stateAndCountry,
      'street': street,
      'city': city,
      'zipAndPostCode': zipAndPostCode,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: map['name'] as String,
      stateAndCountry: map['stateAndCountry'] as String,
      street: map['street'] as String,
      city: map['city'] as String,
      zipAndPostCode: map['zipAndPostCode'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Author.fromJson(String source) =>
      Author.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Author('
        'name: $name, '
        'stateAndCountry: $stateAndCountry, '
        'street: $street, '
        'city: $city, '
        'zipAndPostCode: $zipAndPostCode, '
        'email: $email, '
        'phoneNumber: $phoneNumber'
        ')';
  }

  @override
  bool operator ==(covariant Author other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.stateAndCountry == stateAndCountry &&
        other.street == street &&
        other.city == city &&
        other.zipAndPostCode == zipAndPostCode &&
        other.email == email &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        stateAndCountry.hashCode ^
        street.hashCode ^
        city.hashCode ^
        zipAndPostCode.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode;
  }
}
