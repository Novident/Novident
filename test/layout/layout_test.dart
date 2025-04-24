import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart';
import 'package:novident_remake/src/domain/entities/layout/options/title_options.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_context.dart';
import 'package:novident_remake/src/domain/entities/processor/processor_metadata.dart';
import 'package:novident_remake/src/domain/entities/project/author/author.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document_resource.dart';

void main() {
  final Layout layout = Layout.basic(
    showTitle: true,
    showText: true,
    titleOptions: TitleOptions(
      titlePrefix: 'This is a header prefix¶',
      titleSuffix: '',
      attrPreffix: SectionAttributes.common(align: 'center'),
      attrSuffix: SectionAttributes.common(align: 'center'),
      lettercasePreffix: LetterCase.uppercase,
      lettercaseSuffix: LetterCase.uppercase,
    ),
  );
  final ProcessorContext context = ProcessorContext(
    resources: <DocumentResource>[],
    documentVariables: <String>[],
    shouldWritePageOptions: false,
    currentDocument: Document.empty(details: NodeDetails.zero()),
    language: 'en',
    charsCount: 20,
    wordsCount: 7,
    processPlaceholderAtEnd: false,
    linecount: 1,
    author: Author(),
    metadata: ProjectMetadata.basic(),
    rawProjectName: '',
    jumpToDocument: (value) {
      return null;
    },
    placeholderDisabled: false,
  );

  test('should transform basic content', () {
    final Document doc = Document(
      details: NodeDetails.zero(),
      content: Delta()..insert('And, <\$wc> this is an example part of text\n'),
      name: 'Basic document name',
    );
    context.currentDocument = doc;
    final Delta result = layout.applyLayout(
      doc,
      context,
    );
    expect(
      result,
      Delta()
        ..insert(
          'This is a header prefix',
          {'size': 12.0, 'family': 'arial'},
        )
        ..insert(
          '\n',
          {'line-height': 1.0, 'align': 'center'},
        )
        ..insert(
          'Basic document name',
          {'size': 16.0, 'family': 'arial'},
        )
        ..insert(
          '\n',
          {'line-height': 1.0, 'align': 'left'},
        )
        ..insert('And, 7 this is an example part of text\n'),
    );
  });

  test('should transform basic content without process placeholder yet', () {
    // with this, we tell to the context to no process the
    // placeholders until the Compilation ends
    context.processPlaceholderAtEnd = true;
    final Document doc = Document(
      details: NodeDetails.zero(),
      content: Delta()..insert('And, <\$wc> this is an example part of text\n'),
      name: 'Basic document name',
    );
    context.currentDocument = doc;
    final Delta result = layout.applyLayout(
      doc,
      context,
    );
    expect(
      result,
      Delta()
        ..insert(
          'This is a header prefix',
          {'size': 12.0, 'family': 'arial'},
        )
        ..insert(
          '\n',
          {'line-height': 1.0, 'align': 'center'},
        )
        ..insert(
          'Basic document name',
          {'size': 16.0, 'family': 'arial'},
        )
        ..insert(
          '\n',
          {'line-height': 1.0, 'align': 'left'},
        )
        ..insert('And, <\$wc> this is an example part of text\n'),
    );
  });
}
