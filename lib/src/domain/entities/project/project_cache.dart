import 'package:meta/meta.dart';
import 'package:novident_remake/src/domain/changes/node_change.dart';
import 'package:novident_remake/src/domain/common/property_notifier.dart';
import 'package:novident_remake/src/domain/entities/node/node.dart';
import 'package:novident_remake/src/domain/entities/tree_node/root_node.dart';
import 'package:novident_remake/src/domain/exceptions/disposed_cache_exception.dart';
import 'package:novident_remake/src/domain/extensions/extensions.dart';

class ProjectCache {
  final PropertyValueNotifier<int> templatePosition;
  final PropertyValueNotifier<int> researchPosition;
  final PropertyValueNotifier<int> manuscriptPosition;
  bool _disposed = false;

  ProjectCache({
    int templatePosition = -1,
    int researchPosition = -1,
    int manuscriptPosition = -1,
  })  : templatePosition = PropertyValueNotifier<int>(templatePosition),
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
        templatePosition.value = -1;
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
        if (change.to.level > 0 ||
            change.to.isTrashFolder ||
            change.to is! Root) {
          templatePosition.value = -1;
          return;
        }
        // is at the root, but was moved
        final Node? root = change.to is! Root ? node.jumpToParent() : change.to;
        if (root == null) {
          throw StateError('Root wasn\'t founded while using '
              'jumpToParent() method that should get the '
              'Root owner too');
        }
        final int indexOf = root.cast<Root>().indexWhere(
              (el) => el.isTemplatesSheetFolder,
            );
        templatePosition.value = indexOf.toInt();
        return;
      }
      if (node.isManuscriptFolder && change.to is Root) {
        // is at the root, but was moved
        final Node? root = change.to is! Root ? node.jumpToParent() : change.to;
        if (root == null) {
          throw StateError('Root wasn\'t founded while using '
              'jumpToParent() method that should get the '
              'Root owner too');
        }
        final int indexOf = root.cast<Root>().indexWhere(
              (el) => el.isManuscriptFolder,
            );
        manuscriptPosition.value = indexOf.toInt();
      }
    }
    if (change is NodeMoveChange) {
      final Node node = change.newState;
      // was moved to a position that is not valid
      // for the templates folder
      if (node.isTemplatesSheetFolder) {
        if (change.to is! Root) {
          templatePosition.value = -1;
          return;
        }
        // is at the root, but was moved
        final Node? root = node.jumpToParent();
        if (root == null) {
          throw StateError('Root wasn\'t founded while using '
              'jumpToParent() method that should get the '
              'Root owner too');
        }
        final int indexOf = root.cast<Root>().indexWhere(
              (el) => el.isTemplatesSheetFolder,
            );
        templatePosition.value = indexOf.toInt();
        return;
      }
      if (node.isManuscriptFolder) {
        // is at the root, but was moved
        final Node? root = change.to is! Root ? node.jumpToParent() : change.to;
        if (root == null) {
          throw StateError('Root wasn\'t founded while using '
              'jumpToParent() method that should get the '
              'Root owner too');
        }
        final int indexOf = root.cast<Root>().indexWhere(
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
        templatePosition,
        researchPosition,
        manuscriptPosition,
      ]);
}
