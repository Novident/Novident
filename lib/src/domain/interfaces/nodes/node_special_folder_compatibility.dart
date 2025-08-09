mixin NodeHasSpecialFolderCompatibility {
  /// Special folder considered is just:
  /// ManuscriptFolder
  bool get canMoveIntoSpecialFolders;

  bool get canMoveIntoAnotherFolders;
}
