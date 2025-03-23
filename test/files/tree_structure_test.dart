import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
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
              name: 'Document 1',
            ),
            Folder.testing(
              details: NodeDetails.byId(level: 0, id: 'x2'),
              content: Delta(),
              name: 'Folder 1',
              children: [
                Document(
                  details: NodeDetails.byId(level: 1, id: 'x1-2'),
                  name: 'Document 2',
                  content: Delta(),
                ),
                Document(
                  details: NodeDetails.byId(level: 1, id: 'x2-2'),
                  name: 'Document 3',
                  content: Delta(),
                ),
                Folder.testing(
                  children: [],
                  name: 'Folder 2',
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
