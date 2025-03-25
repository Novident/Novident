import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/data/processors/processor_configurations.dart';
import 'package:novident_remake/src/data/processors/processor_result.dart';
import 'package:novident_remake/src/data/processors/project_processor.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/format/replacement_values.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_attributes.dart';
import 'package:novident_remake/src/domain/entities/layout/options/section_separators_options.dart';
import 'package:novident_remake/src/domain/entities/layout/separators/layout_separator.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/project.dart';
import 'package:novident_remake/src/domain/entities/project/section/section.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/document.dart';
import 'package:novident_remake/src/domain/entities/tree_node/folder.dart';
import 'package:novident_remake/src/domain/enums/project_format_scope.dart';

import '../project/generators/basic_project.dart';

void main() {
  late Project project;
  setUp(() {
    project = generateBasicProject(
      // configure the section types
      // for every level of the tree
      //
      // this is used commonly when the Node
      // has an attachedSection that is equals
      // to ProjectDefaults.kStructuredBasedSectionId
      sectionConfig: SectionTypeConfigurations(
        outlineFolder: <String, String>{
          '0': '#0',
          '1': '#1',
        },
        outlineDocs: <String, String>{
          '0': '#0',
          '1': '#2',
        },
      ),
      manuscriptChildren: [
        Document(
          details: NodeDetails.withLevel(0),
          content: Delta()
            ..insert('This is just a simple doc into the root of the project')
            ..insert('\n'),
          name: 'Doc name 2.1',
          synopsis: '',
          trashOptions: NodeTrashedOptions.nonTrashed(),
        ),
        Folder(
          content: Delta(),
          name: 'Chapter 1',
          details: NodeDetails.withLevel(1),
          children: <Node>[
            Document(
              details: NodeDetails.withLevel(2),
              content: Delta()
                ..insert('This is just a simple doc ')
                ..insert('document where we test how this ')
                ..insert('\n'),
              name: 'Doc name 1',
              synopsis: '',
              trashOptions: NodeTrashedOptions.nonTrashed(),
            ),
            Document(
              details: NodeDetails.withLevel(2),
              content: Delta()
                ..insert('And, This is just a simple secundary doc ')
                ..insert('document where we test how this ')
                ..insert('\n'),
              name: 'Doc name 2',
              synopsis: '',
              trashOptions: NodeTrashedOptions.nonTrashed(),
            ),
          ],
        ),
        Folder(
          content: Delta(),
          name: 'Chapter 2',
          details: NodeDetails.withLevel(1),
          children: <Node>[
            Document(
              details: NodeDetails.withLevel(2),
              content: Delta()
                ..insert('This is just a simple doc into Chapter 2 ')
                ..insert('document where we test how this ')
                ..insert('\n'),
              name: 'Doc name 2.1',
              synopsis: '',
              trashOptions: NodeTrashedOptions.nonTrashed(),
            ),
            Document(
              details: NodeDetails.withLevel(2),
              content: Delta()
                ..insert('This is just a simple secundary doc into Chapter 2 ')
                ..insert('document where we test how this ')
                ..insert('\n'),
              name: 'Doc name 2.2',
              synopsis: '',
              trashOptions: NodeTrashedOptions.nonTrashed(),
            ),
          ],
        ),
      ],
      // adds the sections to be used by used by the section configs
      // and to be assigned to the layouts
      sections: <Section>[
        Section(id: '#0', name: 'Base'),
        Section(id: '#1', name: 'Chapter heading'),
        Section(id: '#2', name: 'Scene'),
      ],
      format: Format(
        id: '12',
        name: 'Basic format',
        fontFamily: Constant.kDefaultFormatFontFamily,
        canChange: false,
        replacements: ReplacementsValues(replacements: <Replacement>{}),
        scope: FormatScope.project,
        layouts: <Layout>[
          Layout.basic(
            id: 'l1',
            assigned: '#0',
            name: 'Base group',
            separatorOptions: SeparatorOptions.common(
              beforeSection: SingleReturnSeparatorStrategy.instance,
              betweenSection: CustomSeparatorStrategy(
                breakAfter: false,
                content: '\n--Basic group--\n',
              ),
              afterSection: SingleReturnSeparatorStrategy.instance,
            ),
            showTitle: false,
            showText: true,
            textAttr: SectionAttributes.common(
              fontSize: 13,
            ),
          ),
          Layout.basic(
            id: 'l2',
            assigned: '#1',
            separatorOptions: SeparatorOptions.common(
              beforeSection: PageBreakSeparatorStrategy.instance,
            ),
            name: 'Chapter heading',
            showTitle: true,
            showText: false,
            titleAttr: SectionAttributes.common(bold: true, align: 'center'),
          ),
          Layout.basic(
            id: 'l3',
            assigned: '#2',
            name: 'Base group',
            separatorOptions: SeparatorOptions.common(
              afterSection: EmptyLineSeparatorStrategy.instance,
            ),
            showTitle: false,
            showText: true,
            textAttr: SectionAttributes.common(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  });

  test('should transform project to an useful docs result', () {
    final ProcessorResult result = ProjectProcessor.process(
      project,
      ProcessorConfiguration(),
    );
    debugPrint(result.documents
        .map((e) => e.content)
        .join('\n--Page break--\n')
        .toString());
  });
}
