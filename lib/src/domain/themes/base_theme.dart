import 'package:flutter/material.dart';

/// A base class that represents the theme that will be used by Novident
abstract class BaseNovidentTheme {
  Color get pureWhite => Colors.white;
  Color get backgroundColor;
  Color get cardsColor;
  Color get drawerBackgroundColor;
  Color get documentSelectedColor;
  Color get folderSelectedColor;
  Color get dialogBackgrondColor;
  Color get inactiveButtonColor;
  Color get activeButtonColor;

  // editor use these vars
  Color get cursorColor;

  /// Applies the color to the TextBoxes of the selection
  Color get editorRectSelectionColor;

  /// Applies the color to the text into the selection
  Color get editorTextSelectedColor;

  /// Applies the color to the text of the editor
  Color get editorTextColor;

  // tree use these vars
  // common
  Color get unnamedDocumentTitleColor;
  Color get unnamedFolderTitleColor;
  // trash
  Color get trashedDocumentColor;
  Color get trashedDocumentTitleColor;
  Color get trashedFolderColor;
  Color get trashedFolderTitleColor;
  Color get trashedIconColor;

  // layout editor use these vars
  /// Applies the color to the buttons that are active into the layout editor
  Color get layoutEditorActiveButtonColor;

  /// Applies the color to the buttons that are inactive into the layout editor
  Color get layoutEditorInactiveButtonColor;
  Color get layoutEditorDeactivedToolbarColor;
}
/*
  //THEMES COLOR
  //NEWSPRINT COLROS
  static const Color background_news = pure_white;
  static const Color card_news = Color.fromARGB(255, 203, 203, 203);
  static const Color drawer_background_news = Color.fromRGBO(251, 251, 251, 1);
  static const Color word_colors_news =
      Color.fromARGB(255, 21, 17, 1); //apply to titles, and buttons
  static const Color selected_folder_widget_color_news =
      word_colors_news; //include the name
  static const Color selection_background_editor_color_news =
      Color.fromARGB(255, 201, 201, 201);
  static const Color selection_word_editor_news = pure_white;
  static const Color button_selected_colors_news = Color.fromARGB(255, 0, 180, 252);
  static const Color selected_document_widget_color_light = pure_white;
  static const Color selected_document_background_color_light =
      Color.fromARGB(255, 110, 116, 120);
  static const Color card_color_light = Color.fromARGB(255, 241, 241, 241);
  static const Color card_color_light_border = Color.fromARGB(255, 140, 140, 138);

  //DARK WRITE COLORS
  static const Color background_black = Color.fromARGB(255, 29, 31, 34);

  static const Color secundary_color_dark = Color.fromARGB(255, 141, 194, 255);
  static const Color drawer_background_dark = Color.fromARGB(255, 46, 48, 51);
  static const Color grey_dark = Color.fromARGB(255, 63, 63, 63);
  static const Color word_colors_dark = pure_white;
  static const Color primary_dark_color = Color.fromARGB(255, 183, 111, 255);
  static const Color primary_dark_color_light = Color.fromARGB(255, 211, 168, 255);
  static const Color expansion_collapsed_color_dark = Color.fromARGB(255, 183, 183, 183);
  static const Color cursor_color_dark = pure_white;
  static const Color selected_document_widget_color_dark = pure_white;
  static const Color selected_document_background_color_dark =
      Color.fromARGB(255, 34, 34, 34);
  static const Color popup_color_background = Color.fromARGB(255, 66, 70, 74);
  static const Color selection_background_editor_color_dark =
      Color.fromARGB(255, 74, 137, 220);
  static const Color buttons_color = Color.fromARGB(255, 255, 198, 165);
  static const Color light_pink = Color.fromARGB(255, 199, 161, 255);

  static const Color light_pink_darker_for_button = Color.fromRGBO(186, 140, 255, 1);
  static const Color pink_to_violet_dark_theme_for_button =
      Color.fromARGB(255, 161, 98, 255);
  static const Color violet = Color.fromARGB(255, 131, 48, 255);
  static const Color violetBrightness = Color.fromARGB(255, 199, 116, 255);
  static const Color trashed_color = Color.fromARGB(255, 136, 136, 136);

  static const Color editor_layout_section_selected = Color.fromARGB(255, 90, 90, 90);

  static const Color toolbar_layout_deactivated_background =
      Color.fromARGB(255, 83, 83, 83);
  static const TextStyle unnamedFileStyle =
      TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

  static const TextStyle titleStyle =
      TextStyle(fontSize: 27.5, fontWeight: FontWeight.w900);
  static const TextStyle subtitleStyle =
      TextStyle(fontSize: 18.5, fontWeight: FontWeight.w900);
*/
