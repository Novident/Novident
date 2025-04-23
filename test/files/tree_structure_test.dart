import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';

import 'default/generate_json.dart';

void main() {
  test('should throw error by Root child', () async {
    expect(
        () => Root(
              children: [
                Root(
                  children: [],
                ),
              ],
            ),
        throwsA(
          isA<AssertionError>(),
        ));
  });

  test(
    'should be structured as passed',
    () async {
      expect(
        Root.fromJsonTest(generateTree()),
        Root.testing(
          children: <Node>[
            Document(
              details: NodeDetails.byId(level: 0, id: 'x1'),
              content: Delta(),
              attachedSection: '',
              name: 'Document 1',
            ),
            Folder.testing(
              details: NodeDetails.byId(level: 0, id: 'x2'),
              content: Delta(),
              attachedSection: '',
              name: 'Folder 1',
              children: [
                Document(
                  details: NodeDetails.byId(level: 1, id: 'x1-2'),
                  name: 'Document 2',
                  attachedSection: '',
                  content: Delta(),
                ),
                Document(
                  details: NodeDetails.byId(level: 1, id: 'x2-2'),
                  name: 'Document 3',
                  attachedSection: '',
                  content: Delta(),
                ),
                Folder.testing(
                  children: [],
                  name: 'Folder 2',
                  attachedSection: '',
                  content: Delta(),
                  details: NodeDetails.byId(level: 1, id: 'x3-2'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
