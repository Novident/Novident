import 'package:flutter/foundation.dart'
    show
        DiagnosticsNode,
        DiagnosticsProperty,
        DiagnosticsTreeStyle,
        ErrorDescription,
        FlutterError,
        FlutterErrorDetails;

typedef NotifyCallback<T> = void Function(T data);

/// This is a custom implementation of ChangeNotifier
/// where we can call all the notifiers passing to them the new value
class PropertyValueNotifier<T> {
  static final List<NotifyCallback?> _emptyListeners =
      List<NotifyCallback?>.filled(0, null);
  List<NotifyCallback<T>?> _callbacks = <NotifyCallback<T>?>[];
  int _count = 0;
  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedListeners = 0;
  bool _debugDisposed = false;
  PropertyValueNotifier(T value) : _value = value;

  T get value => _value;
  T _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners(_value);
  }

  void addNotifier(NotifyCallback<T> listener) {
    assert(!_debugDisposed, '');
    if (_count == _callbacks.length) {
      if (_count == 0) {
        _callbacks = List<NotifyCallback<T>?>.filled(1, null);
      } else {
        final List<NotifyCallback<T>?> newListeners =
            List<NotifyCallback<T>?>.filled(
          _callbacks.length * 2,
          null,
        );
        for (int i = 0; i < _count; i++) {
          newListeners[i] = _callbacks[i];
        }
        _callbacks = newListeners;
      }
    }
    _callbacks[_count++] = listener;
  }

  void dispose() {
    assert(
      _notificationCallStackDepth == 0,
      'The "dispose()" method on $this was called during the call to '
      '"notifyListeners()". This is likely to cause errors since it modifies '
      'the list of listeners while the list is being used.',
    );
    assert(() {
      _debugDisposed = true;
      return true;
    }(), '');
    _callbacks = _emptyListeners;
    _count = 0;
  }

  bool get hasNotifiers => _count > 0;

  void notifyListeners(T value) {
    assert(!_debugDisposed, '');
    if (_count == 0) {
      return;
    }

    // To make sure that listeners removed during this iteration are not called,
    // we set them to null, but we don't shrink the list right away.
    // By doing this, we can continue to iterate on our list until it reaches
    // the last listener added before the call to this method.

    // To allow potential listeners to recursively call notifyListener, we track
    // the number of times this method is called in _notificationCallStackDepth.
    // Once every recursive iteration is finished (i.e. when _notificationCallStackDepth == 0),
    // we can safely shrink our list so that it will only contain not null
    // listeners.

    _notificationCallStackDepth++;

    final int end = _count;
    for (int i = 0; i < end; i++) {
      try {
        _callbacks[i]?.call(value);
      } catch (exception, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'foundation library',
            context: ErrorDescription(
                'while dispatching notifications for $runtimeType'),
            informationCollector: () => <DiagnosticsNode>[
              DiagnosticsProperty<PropertyValueNotifier<T>>(
                'The $runtimeType sending notification was',
                this,
                style: DiagnosticsTreeStyle.errorProperty,
              ),
            ],
          ),
        );
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 && _reentrantlyRemovedListeners > 0) {
      // We really remove the listeners when all notifications are done.
      final int newLength = _count - _reentrantlyRemovedListeners;
      if (newLength * 2 <= _callbacks.length) {
        // As in _removeAt, we only shrink the list when the real number of
        // listeners is half the length of our list.
        final List<NotifyCallback<T>?> newListeners =
            List<NotifyCallback<T>?>.filled(newLength, null);

        int newIndex = 0;
        for (int i = 0; i < _count; i++) {
          final NotifyCallback<T>? listener = _callbacks[i];
          if (listener != null) {
            newListeners[newIndex++] = listener;
          }
        }

        _callbacks = newListeners;
      } else {
        // Otherwise we put all the null references at the end.
        for (int i = 0; i < newLength; i += 1) {
          if (_callbacks[i] == null) {
            // We swap this item with the next not null item.
            int swapIndex = i + 1;
            while (_callbacks[swapIndex] == null) {
              swapIndex += 1;
            }
            _callbacks[i] = _callbacks[swapIndex];
            _callbacks[swapIndex] = null;
          }
        }
      }

      _reentrantlyRemovedListeners = 0;
      _count = newLength;
    }
  }

  void removeNotifier(NotifyCallback<T> listener) {
    assert(!_debugDisposed, '');
    // This method is allowed to be called on disposed instances for usability
    // reasons. Due to how our frame scheduling logic between render objects and
    // overlays, it is common that the owner of this instance would be disposed a
    // frame earlier than the listeners. Allowing calls to this method after it
    // is disposed makes it easier for listeners to properly clean up.
    for (int i = 0; i < _count; i++) {
      final NotifyCallback<T>? listenerAtIndex = _callbacks[i];
      if (listenerAtIndex == listener) {
        if (_notificationCallStackDepth > 0) {
          // We don't resize the list during notifyListeners iterations
          // but we set to null, the listeners we want to remove. We will
          // effectively resize the list at the end of all notifyListeners
          // iterations.
          _callbacks[i] = null;
          _reentrantlyRemovedListeners++;
        } else {
          // When we are outside the notifyListeners iterations we can
          // effectively shrink the list.
          _removeAt(i);
        }
        break;
      }
    }
  }

  void _removeAt(int index) {
    // The list holding the listeners is not growable for performances reasons.
    // We still want to shrink this list if a lot of listeners have been added
    // and then removed outside a notifyListeners iteration.
    // We do this only when the real number of listeners is half the length
    // of our list.
    _count -= 1;
    if (_count * 2 <= _callbacks.length) {
      final List<NotifyCallback<T>?> newListeners =
          List<NotifyCallback<T>?>.filled(_count, null);

      // Listeners before the index are at the same place.
      for (int i = 0; i < index; i++) {
        newListeners[i] = _callbacks[i];
      }

      // Listeners after the index move towards the start of the list.
      for (int i = index; i < _count; i++) {
        newListeners[i] = _callbacks[i + 1];
      }

      _callbacks = newListeners;
    } else {
      // When there are more listeners than half the length of the list, we only
      // shift our listeners, so that we avoid to reallocate memory for the
      // whole list.
      for (int i = index; i < _count; i++) {
        _callbacks[i] = _callbacks[i + 1];
      }
      _callbacks[_count] = null;
    }
  }
}
