import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/enums.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_attach_sections.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_can_be_trashed.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_name.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_resource.dart';

extension EasyTypeNodeExtension on Node {
  // folder
  bool get isFolder => this is Folder;
  bool get isNormalFolder => isFolder && cast<Folder>().type.isNormalFolder;
  bool get isManuscriptFolder =>
      isFolder && cast<Folder>().type.isManuscriptFolder;
  bool get isTrashFolder => isFolder && cast<Folder>().type.isTrashFolder;
  bool get isResearchFolder => isFolder && cast<Folder>().type.isResearchFolder;
  bool get isTemplatesSheetFolder =>
      isFolder && cast<Folder>().type.isTemplatesSheetFolder;

  // docs
  bool get isDocument => this is Document;
  bool get isDocumentResource => this is DocumentResource;

  // mixins
  bool get isTrashed =>
      this is NodeCanBeTrashed &&
      cast<NodeCanBeTrashed>().trashStatus.isTrashed;
  bool get nodeHasName => this is NodeHasName;
  bool get nodeHasResource => this is NodeHasResource;
  bool get nodeCanBeTrashed => this is NodeCanBeTrashed;
  bool get nodeCanAttachSections => this is NodeCanAttachSections;
}
