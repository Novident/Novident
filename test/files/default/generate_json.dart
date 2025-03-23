import 'package:flutter_quill/quill_delta.dart';
import 'package:novident_remake/src/domain/entities/node/node_details.dart';
import 'package:novident_remake/src/domain/entities/trash/node_trashed_options.dart';

Map<String, dynamic> generateTree() {
  return <String, dynamic>{
    'isRoot': true,
    'details': NodeDetails.byId(level: -1, id: 'root').toJson(),
    'children': <Map<String, dynamic>>[
      // document
      <String, dynamic>{
        'isFile': true,
        'details': NodeDetails.byId(level: 0, id: 'x1').toJson(),
        'content': Delta().toJson(),
        'name': 'Document 1',
        'trashOptions': NodeTrashedOptions.nonTrashed().toJson(),
      },
      // folder
      <String, dynamic>{
        'isFolder': true,
        'expanded': false,
        'content': Delta().toJson(),
        'type': 0, 
        'trashOptions': NodeTrashedOptions.nonTrashed().toJson(),
        'name': 'Folder 1',
        'details': NodeDetails.byId(level: 0, id: 'x2').toJson(),
        'children': [
          // documents
          <String, dynamic>{
            'isFile': true,
            'content': Delta().toJson(),
            'name': 'Document 2',
            'trashOptions': NodeTrashedOptions.nonTrashed().toJson(),
            'details': NodeDetails.byId(level: 1, id: 'x1-2').toJson(),
          },
          <String, dynamic>{
            'isFile': true,
            'content': Delta().toJson(),
            'name': 'Document 3',
            'trashOptions': NodeTrashedOptions.nonTrashed().toJson(),
            'details': NodeDetails.byId(level: 1, id: 'x2-2').toJson(),
          },
          // folder
          <String, dynamic>{
            'isFolder': true,
            'children': [],
            'content': Delta().toJson(),
            'name': 'Folder 2',
            'type': 0, 
            'trashOptions': NodeTrashedOptions.nonTrashed().toJson(),
            'expanded': false,
            'details': NodeDetails.byId(level: 1, id: 'x3-2').toJson(),
          },
        ],
      },
    ],
  };
}
