 null) != hadHandler) {
      markNeedsSemanticsUpdate();
    }
  }

  /// Called when the user presses on the render object for a long period of time.
  GestureLongPressCallback? get onLongPress => _onLongPress;
  GestureLongPressCallback? _onLongPress;
  set onLongPress(GestureLongPressCallback? value) {
    if (_onLongPress == value) {
      return;
    }
    final bool hadHandler = _onLongPress != null;
    _onLongPress = value;
    if ((value != null) != hadHandler) {
      markNeedsSemanticsUpdate();
    }
  }

  /// Called when the user scrolls to the left or to the right.
  GestureDragUpdateCallback? get onHorizontalDragUpdate => _onHorizontalDragUpdate;
  GestureDragUpdateCallback? _onHorizontalDragUpdate;
  set onHorizontalDragUpdate(GestureDragUpdateCallback? value) {
    if (_onHorizontalDragUpdate == value) {
      return;
    }
    final bool hadHandler = _onHorizontalDragUpdate != null;
    _onHorizontalDragUpdate = value;
    if ((value != null) != hadHandler) {
      markNeedsSemanticsUpdate();
    }
  }

  /// Called when the user scrolls up or down.
  GestureDragUpdateCallback? get onVerticalDragUpdate => _onVerticalDragUpdate;
  GestureDragUpdateCallback? _onVerticalDragUpdate;
  set onVerticalDragUpdate(GestureDragUpdateCallback? value) {
    if (_onVerticalDragUpdate == value) {
      return;
    }
    final bool hadHandler = _onVerticalDragUpdate != null;
    _onVerticalDragUpdate = value;
    if ((value != null) != hadHandler) {
      markNeedsSemanticsUpdate();
    }
  }

  /// The fraction of the dimension of this render box to use when
  /// scro