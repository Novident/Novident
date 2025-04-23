enum FolderType {
  normal,
  templatesSheet,
  research,
  manuscript,
  trash,
}

extension EasyFolderType on FolderType {
  //
  bool get isNormalFolder => this == FolderType.normal;
  bool get isTemplatesSheetFolder => this == FolderType.templatesSheet;
  bool get isResearchFolder => this == FolderType.research;
  bool get isManuscriptFolder => this == FolderType.manuscript;
  bool get isTrashFolder => this == FolderType.trash;
  //
  bool get isNotNormalFolder => !isNormalFolder;
  bool get isNotTemplatesSheetFolder => !isTemplatesSheetFolder;
  bool get isNotResearchFolder => !isResearchFolder;
  bool get isNotManuscriptFolder => !isManuscriptFolder;
  bool get isNotTrashFolder => !isTrashFolder;
}
