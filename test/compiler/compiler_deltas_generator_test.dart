import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novident_remake/src/data/processors/project_processor.dart';
import 'package:novident_remake/src/domain/constants.dart';
import 'package:novident_remake/src/domain/entities/format/format.dart';
import 'package:novident_remake/src/domain/entities/format/replacement_values.dart';
import 'package:novident_remake/src/domain/entities/layout/layout.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/project/section/section.dart';
import 'package:novident_remake/src/domain/entities/project/section/section_types_configuration.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';
import 'package:novident_remake/src/domain/entities/tree_node/file.dart';
import 'package:novident_remake/src/domain/enums/project_format_scope.dart';

import '../project/generators/basic_project.dart';

void main() {
  test('should transform project to an useful docs result', () {
    final ProcessorResult? result = ProjectProcessor.process(
      generateBasicProject(
        sectionConfig: SectionTypeConfigurations(
          outlineFolder: <String, String>{
            '0': '#1',
            '1': '#2',
          },
          outlineDocs: <String, String>{
            '0': '#2',
            '1': '#3',
            '2': '#3',
          },
        ),
        manuscriptChildren: [
          Document(
            details: NodeDetails.zero(),
            content: Delta(),
            name: 'Doc name',
            synopsis: '',
            trashOptions: NodeTrashedOptions.nonTrashed(),
          ),
          Document(
            details: NodeDetails.zero(),
            content: Delta(),
            name: 'Doc name 2',
            synopsis: '',
            trashOptions: NodeTrashedOptions.nonTrashed(),
          ),
        ],
        sections: <Section>[
          Section(id: '#1', name: 'My section name 1'),
          Section(id: '#2', name: 'My section name 2'),
          Section(id: '#3', name: 'My section name 3'),
          Section(id: '#4', name: 'My section name 4'),
        ],
      ),
      ProcessorConfiguration(
        format: Format(
          id: '1',
          name: 'Basic format',
          fontFamily: Constant.kDefaultFormatFontFamily,
          layouts: <Layout>[
            Layout.basic(id: 'l1', assigned: '#1'),
            Layout.basic(id: 'l2', assigned: '#2'),
            Layout.basic(id: 'l3', assigned: '#3'),
            Layout.basic(id: 'l4', assigned: '#1'),
          ],
          canChange: false,
          replacements: ReplacementsValues(replacements: <Replacement>{}),
          scope: FormatScope.project,
        ),
      ),
    );
  });
}
