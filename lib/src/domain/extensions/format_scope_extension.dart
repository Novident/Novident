import 'package:novident_remake/src/domain/enums/format_scope.dart';

extension FormatScopeExtension on FormatScope {
  bool get isGlobal => this == FormatScope.global;
  bool get isNovident => this == FormatScope.novident;
  bool get isProject => this == FormatScope.project;
  bool get isUnknown => this == FormatScope.unknown;
  bool get noScope => this == FormatScope.noScope;
}
