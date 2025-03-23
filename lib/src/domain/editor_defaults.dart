class EditorDefaults {
  static const double kDefaultLineHeight = 1.0;
  static const String kDefaultFontSize = '12';
  static const String kDefaultFontFamily = 'arial';

  static const Map<String, String> kDefaultEditorFontSizes = <String, String>{
    "Tiny": "small",
    "Normal": "16",
    "Large": "large",
    "Huge": "huge",
    "Subtitle": "23",
    "Title": "28",
  };

  static const Map<String, String> kDefaultFontFamilies = <String, String>{
    "Monospace": "monospace",
    "Raleway": "Raleway",
    "Arial": "arial",
    "Courier": "Courier",
    "Inria Serif": "InriaSerif",
    "Noto Sans": "NotoSans",
    "Open Sans": "OpenSans",
    "Ubuntu Mono": "UbuntuMono",
    "Tinos": "Tinos",
  };

  /// These are heading sizes used by the compiler to 
  static const List<double> kDefaultHeadingSizes = <double>[
    29.5,
    26.5,
    23,
    20,
    17,
    15.5
  ];

  static const List<double> kDefaultLineheights = <double>[
    1.0,
    1.15,
    1.5,
    2.0
  ];

  static const List<int> kDefaultLayoutEditorFontSizes = <int>[
    8,
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    26,
    28,
    30,
    32,
    34,
    36,
    38,
    40,
    42,
    44,
    46,
    48,
    50
  ];
}
