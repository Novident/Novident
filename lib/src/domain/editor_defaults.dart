class EditorDefaults {
  static const double kDefaultLineHeight = 1.0;
  static const String kDefaultFontSize = '12';
  static const String kDefaultFontFamily = 'arial';
  static const Map<String, String> fontSizes = <String, String>{
    "Tiny": "small",
    "Normal": "16", //clear to make the transform assign DEFAULT_FONT_SIZE -> 12
    "Large": "large",
    "Huge": "huge",
    "Subtitle": "23",
    "Title": "28",
  };
  static const Map<String, String> fontFamilies = <String, String>{
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

  static const List<double> default_heading_size = <double>[
    29.5,
    26.5,
    23,
    20,
    17,
    15.5
  ];
  static const List<double> spacing = <double>[1.0, 1.15, 1.5, 2.0];
  static const List<double> default_editor_spacing = <double>[
    1.0,
    1.15,
    1.5,
    2.0
  ];

  static const List<int> sizes = <int>[
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
