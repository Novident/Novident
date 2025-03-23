import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:dart_quill_delta_simplify/dart_quill_delta_simplify.dart';
import 'package:novident_remake/src/domain/entities/compiler/compiler_context.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/rule/placeholder/placeholder_rule_mixin.dart';
import 'package:novident_remake/src/domain/extensions/cast_extension.dart';
import 'package:novident_remake/src/domain/interfaces/node_has_value.dart';
import 'package:novident_remake/src/domain/interfaces/node_resource.dart';
import 'package:novident_remake/src/domain/project_defaults.dart';

final class ReplaceImagePlaceholderRule with PlaceholderRule {
  const ReplaceImagePlaceholderRule();

  @override
  RegExp get pattern => ProjectDefaults.kImagePattern;

  @override
  bool checkIfNeedApply(Delta delta) => delta.contains(
        target: pattern,
        usePlainText: true,
      );

  @override
  Delta apply(Delta delta, CompilerContext context) {
    return delta.toQuery
        .replaceAllMapped(
          target: pattern.pattern,
          replaceBuilder: (
            String data,
            Map<String, dynamic>? attributes,
            DeltaRange curRange,
            DeltaRange matchRange,
          ) {
            // old implementation
            // ```
            // final RegExpMatch match = _imagePattern.firstMatch(data)!;
            // final String src = match.group(1)!;
            // ```
            //
            // Context:
            //
            // We split these values since those could be like:
            //
            // ```
            //  <$img:BookImageRefName;w=20;h=300:cover>
            //  <$img:BookImageRefName>
            // ```
            //
            // So, we need to get all properties to apply these ones to the image
            // Note: if empty means the tag has just the name reference like: <$img:BookImage>
            final List<String> properties = data.split(';');
            if (properties.isEmpty) {
              final Node? file = context.queryResource(data);
              if (file == null ||
                  file is! NodeHasValue<Delta> && (file is! NodeHasResource)) {
                return [];
              }
              final String imagePath =
                  file.cast<NodeHasResource>().resource(ResourceType.image) as String;
              if (imagePath.isEmpty) return [];
              return <Operation>[
                Operation.insert(<String, String>{'image': imagePath})
              ];
            }
            final String fileName = properties.first;
            final Node? file = context.queryResource(fileName);
            if (file == null || (file is! NodeHasResource)) {
              return <Operation>[];
            }
            final String imagePath =
                file.cast<NodeHasResource>().resource(ResourceType.image) as String;
            if (imagePath.isEmpty) return [];
            final String? width = properties
                .where((String element) => element.startsWith('w='))
                .firstOrNull;
            final String? height = properties
                .where((String element) => element.startsWith('h='))
                .firstOrNull;
            return <Operation>[
              Operation.insert(
                <String, String>{'image': imagePath},
                <String, String>{
                  'style': 'width:$width;height:$height;',
                },
              )
            ];
          },
        )
        .build()
        .delta;
  }

  @override
  QueryDelta setConditionRule(QueryDelta query, CompilerContext context) {
    return query.replaceAllMapped(
      target: pattern.pattern,
      replaceBuilder: (
        String data,
        Map<String, dynamic>? attributes,
        DeltaRange curRange,
        DeltaRange matchRange,
      ) {
        // old implementation
        // ```
        // final RegExpMatch match = _imagePattern.firstMatch(data)!;
        // final String src = match.group(1)!;
        // ```
        //
        // Context:
        //
        // We split these values since those could be like:
        //
        // ```
        //  <$img:BookImageRefName;w=20;h=300:cover>
        //  <$img:BookImageRefName>
        // ```
        //
        // So, we need to get all properties to apply these ones to the image
        // Note: if empty means the tag has just the name reference like: <$img:BookImage>
        final List<String> properties = data.split(';');
        if (properties.isEmpty) {
          final Node? file = context.queryResource(data);
          if (file == null ||
              file is! NodeHasValue<Delta> && (file is! NodeHasResource)) {
            return [];
          }
          final String imagePath =
              file.cast<NodeHasResource>().resource(ResourceType.image) as String;
          if (imagePath.isEmpty) return [];
          return <Operation>[
            Operation.insert(<String, String>{'image': imagePath})
          ];
        }
        final String fileName = properties.first;
        final Node? file = context.queryResource(fileName);
        if (file == null || (file is! NodeHasResource)) {
          return <Operation>[];
        }
        final String imagePath =
            file.cast<NodeHasResource>().resource(ResourceType.image) as String;
        if (imagePath.isEmpty) return [];
        final String? width =
            properties.where((String element) => element.startsWith('w=')).firstOrNull;
        final String? height =
            properties.where((String element) => element.startsWith('h=')).firstOrNull;
        return <Operation>[
          Operation.insert(
            <String, String>{'image': imagePath},
            <String, String>{
              'style': 'width:$width;height:$height;',
            },
          )
        ];
      },
    );
  }
}
