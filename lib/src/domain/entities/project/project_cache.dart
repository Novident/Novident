import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/common/property_notifier.dart';
import 'package:novident_nodes/novident_nodes.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/exceptions/disposed_cache_exception.dart';
import 'package:novident_remake/src/domain/exceptions/illegal_operation.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';

class ProjectCache {
  final PropertyValueNotifier<List<int>> templatePosition;
  final PropertyValueNotifier<int> researchPosition;
  final PropertyValueNotifier<int> manuscriptPosition;
  bool _disposed = false;

  ProjectCache({
    List<int>? templatePosition,
    int researchPosition = -1,
    int manuscriptPosition = -1,
  })  : templatePosition =
            PropertyValueNotifier<List<int>>(templatePosition ?? []),
        researchPosition = PropertyValueNotifier<int>(researchPosition),
        manuscriptPosition = PropertyValueNotifier<int>(manuscriptPosition);

  @visibleForTesting
  bool get isDisposed => _disposed;

  /// this allow to us track always the position of template, manuscript
  /// and research folders without making too much code
  void listenChanges(NodeChange change) {
    if (_disposed) {
      throw DisposedCacheException(fromCache: 'ProjectCache');
    }
    if (change is NodeDeletion) {
      final Node node = change.newState;
      if (node.isTemplatesSheetFolder) {
        templatePosition.value = <int>[];
        return;
      }
      if (node.isManuscriptFolder) {
        manuscriptPosition.value = -1;
      }
    }
    if (change is NodeInsertion) {
      final Node node = change.newState;
      // was moved to a position that is not valid
      // for the templates folder
      if (node.isTemplatesSheetFolder) {
        if (change.to.isTrashFolder || change.to.isTrashed) {
          templatePosition.value = [];
          return;
        }
        final Node? templatesheet = change.to
            .cast<NodeContainer>()
            .firstWhereOrNull((Node el) => el.isTemplatesSheetFolder);
        assert(
            templatesheet != null,
            'templatesheet was inserted in '
            '${change.to.runtimeType}(${change.to.id}) but was not founded');
        templatePosition.value = templatesheet!.findNodePath();
        assert(
            templatePosition.value.isNotEmpty,
            'templatesheet has no a defined path '
            'while the TemplateSheetFolder exist in project');
        return;
      }
      if (node.isManuscriptFolder && change.to is Root) {
        // is at the root, but was moved
        final Node root = change.to is! Root ? node.jumpToParent() : change.to;
        final int indexOf =
            root.cast<Root>().indexWhere((el) => el.isManuscriptFolder);
        manuscriptPosition.value = indexOf;
      }
    }
    if (change is NodeMoveChange) {
      final Node node = change.newState;
      // was moved to a position that is not valid
      // for the templates folder
      if (node.isTemplatesSheetFolder) {
        // is at the root, but was moved
        final Node? templatesheet = change.to
            .cast<NodeContainer>()
            .firstWhereOrNull((Node el) => el.isTemplatesSheetFolder);
        assert(
            templatesheet != null,
            'templatesheet was inserted in '
            '${change.to.runtimeType}(${change.to.id}) but was not founded');
        assert(
            templatePosition.value.isNotEmpty,
            'templatesheet has no a defined path '
            'while the TemplateSheetFolder exist in project');
        return;
      }
      if (node.isManuscriptFolder) {
        if (change.to is! Root) {
          throw IllegalOperationException(
            object: node,
            description: 'The manuscript never '
                'should be added in a node that IS NOT THE ROOT '
                'of the project. Please'
                ' Report this issue at https://github.com/Novident/Novident/issues',
          );
        }
        // is at the root, but was moved
        final Root root = change.to.cast<Root>();
        final int indexOf = root.indexWhere(
          (el) => el.isManuscriptFolder,
        );
        manuscriptPosition.value = indexOf.toInt();
      }
    }
  }

  void dispose() {
    if (_disposed) return;
    manuscriptPosition.dispose();
    templatePosition.dispose();
    researchPosition.dispose();
    _disposed = true;
  }

  @override
  bool operator ==(covariant ProjectCache other) {
    if (identical(this, other)) return true;
    return templatePosition.value == other.templatePosition.value &&
        researchPosition.value == other.researchPosition.value &&
        manuscriptPosition.value == other.manuscriptPosition.value;
  }

  @override
  int get hashCode => Object.hashAllUnordered(<Object?>[
        templatePosition.value,
        researchPosition.value,
        manuscriptPosition.value,
      ]);
}
