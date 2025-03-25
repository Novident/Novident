library;

export 'folder_type.dart';
export 'compile_to.dart';

enum SelectedMatter { front, back }

enum LetterCase { uppercase, lowercase, normal }

enum Filters { older, newer, name, reverse, defaultF }

enum Selection { folder, document, both, none, unknown }

enum ActionOperation {
  addAsChildren,
  removeChild,
  updateChild,
  removeThis,
  updateThis,
  addAbove
}

// used by the compiler to add indent based in the selection of ones of theses options
enum IndentType { everyLines, justAfterFirstLine, alwaysAfterAHeader }
