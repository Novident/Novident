import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_has_value.dart';
import 'package:novident_remake/src/domain/interfaces/nodes/node_resource.dart';

void main() {
  test('should be NodeHasValue', () {
    final Node doc = Document.empty(details: NodeDetails.zero(null));
    expect(
      doc is NodeHasValue<Delta>,
      isTrue,
    );
  });

  test('shouldn\'t be NodeHasResource', () {
    final Node doc = Document.empty(details: NodeDetails.zero(null));
    expect(
      doc is NodeHasResource,
      isFalse,
    );
  });

  test('should be NodeHasResource', () {
    final Node doc = DocumentResource.empty(details: NodeDetails.zero(null));
    expect(
      doc is NodeHasResource,
      isTrue,
    );
  });

  test('shouldn\'t be NodeHasResource', () {
    final Node folder = Folder(
        children: [], content: Delta(), name: '', details: NodeDetails.base());
    expect(
      folder is NodeHasResource,
      isFalse,
    );
  });
}
