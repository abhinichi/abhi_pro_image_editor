import 'package:flutter/gestures.dart';

/// A service that tracks the state of mouse buttons (left, right, and middle).
///
/// This service can be used in conjunction with a [Listener] widget to monitor
/// mouse button press and release events.
class MouseService {
  bool _isLeftMousePressed = false;

  /// Whether the left (primary) mouse button is currently pressed.
  bool get isLeftMousePressed => _isLeftMousePressed;

  bool _isRightMousePressed = false;

  /// Whether the right (secondary) mouse button is currently pressed.
  bool get isRightMousePressed => _isRightMousePressed;

  bool _isMiddleMousePressed = false;

  /// Whether the middle mouse button is currently pressed.
  bool get isMiddleMousePressed => _isMiddleMousePressed;

  /// Handles a [PointerDownEvent] to update mouse button press states.
  ///
  /// This method should be called from the `onPointerDown` callback
  /// of a [Listener] widget.
  void onPointerDown(PointerDownEvent event) {
    final buttons = event.buttons;

    _isLeftMousePressed = (buttons & kPrimaryMouseButton) != 0;
    _isRightMousePressed = (buttons & kSecondaryMouseButton) != 0;
    _isMiddleMousePressed = (buttons & kMiddleMouseButton) != 0;
  }

  /// Handles a [PointerUpEvent] to update mouse button release states.
  ///
  /// This method should be called from the `onPointerUp` callback
  /// of a [Listener] widget.
  void onPointerUp(PointerUpEvent event) {
    final buttons = event.buttons;

    _isLeftMousePressed = (buttons & kPrimaryMouseButton) == 0;
    _isRightMousePressed = (buttons & kSecondaryMouseButton) == 0;
    _isMiddleMousePressed = (buttons & kMiddleMouseButton) == 0;
  }
}
