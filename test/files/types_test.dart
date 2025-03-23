import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_value.dart';
import 'package:novident_remake/src/domain/interfaces/node_resource.dart';

void main() {
  test('should be NodeHasValue', () {
    final Node doc = Document.empty(details: NodeDetails.zero(null));
    expect(
      doc is NodeHasValue<Delta>,
      isTrue,
    );
  });

  test('should be NodeHasResource', () {
    final Node doc = Document.empty(details: NodeDetails.zero(null));
    expect(
      doc is NodeHasResource,
      isTrue,
    );
  });

  test('shouldn\'t be NodeHasResource', () {
    final Node folder = Folder(children: [], content: Delta(), name: '', details: NodeDetails.base());
    expect(
      folder is NodeHasResource,
      isFalse,
    );
  });


}
