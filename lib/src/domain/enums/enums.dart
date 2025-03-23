enum SelectedMatter { front, back }

enum LetterCase { uppercase, lowercase, normal }

enum Filters { older, newer, name, reverse, defaultF }

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

enum FolderType { normal, templateSheet, research, manuscript,  trash,   }

enum CompileTo { pdf, html, epub, txt, docx, md }
