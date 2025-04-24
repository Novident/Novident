import 'package:flutter/material.dart';
import 'package:novident_remake/src/domain/entities/layout/separators/layout_separator.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rules.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

class Constant {
  const Constant._();
  static const PlaceholderRules kDefaultRules = PlaceholderRules();
  static const String kDefaultBackupNameForCoverImages = 'nov_cover_images';
  static const String kDefaultDateFormatZone = "yyyy-MM-dd HH:mm:ss Z";
  static const String kWhitespace = ' ';
  static const String kDefaultAsIs = 'As is';
  static const String kDefaultMessageToImportNovidentProject =
      "Select a exported project to use this option. Must end with extension .${ProjectDefaults.kDefaultProjectExtension}";

  static const String kDefaultFormatFontFamily = "by-layout";

  static final LayoutSeparator kDefaultSeparatorStrategy =
      EmptyLineSeparatorStrategy.instance;
  static const String kDefaultAppName = 'Novident';

  static const Map<int, String> kMonths = <int, String>{
    1: 'january',
    2: 'february',
    3: 'march',
    4: 'april',
    5: 'may',
    6: 'june',
    7: 'july',
    8: 'august',
    9: 'september',
    10: 'october',
    11: 'november',
    12: 'december',
  };

  // supported languages
  static const List<String> supportedLangs = [
    'en',
    'es',
    'zh',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru'
  ];
  static const List<Locale> supportedLocaleLangs = [
    Locale('en', 'US'), //english (United States)
    Locale('es'), //spanish
    Locale('zh', 'cn'), //chinese (general)
    Locale('zh', 'hk'), //chinese (hong kong)
    Locale('zh', 'tw'), //chisene (taiwan)
    Locale('fr'), //franche
    Locale('it'), //italian
    Locale('ja'), //japan
    Locale('ko'), //korea
    Locale('pt'), //portuguese
    Locale('ru'), //russian
  ];
}
