import 'package:flutter/gestures.dart';

import '../models/editor_configs/pro_image_editor_configs.dart';

/// A service that tracks the state of mouse buttons (left, right, and middle).
///
/// This service can be used in conjunction with a [Listener] widget to monitor
/// mouse button press and release events.
class MouseService {
  /// A service responsible for handling mouse-related configurations and
  /// actions.
  ///
  /// The [MouseService] class is initialized with the required [configs]
  /// parameter, which contains the necessary settings for mouse operations.
  ///
  /// - [configs]: The configuration object that defines mouse behavior and
  /// settings.
  MouseService({required this.configs});

  /// Configuration options for the Image Editor.
  ProImageEditorConfigs configs;

  bool _isPrimaryMousePressed = false;

  /// Whether the primary (left) mouse button is currently pressed.
  bool get isPrimaryMousePressed => _isPrimaryMousePressed;

  bool _isSecondaryMousePressed = false;

  /// Whether the secondary (right) mouse button is currently pressed.
  bool get isSecondaryMousePressed => _isSecondaryMousePressed;

  bool _isMiddleMousePressed = false;

  /// Whether the middle mouse button is currently pressed.
  bool get isMiddleMousePressed => _isMiddleMousePressed;

  LayerInteractionConfigs get _layerInteractionConfigs =>
      configs.layerInteraction;

  MouseButtonAction get _mouseButtonPrimaryAction =>
      _layerInteractionConfigs.mouseButtonPrimaryAction;
  MouseButtonAction get _mouseButtonSecondaryAction =>
      _layerInteractionConfigs.mouseButtonSecondaryAction;
  MouseButtonAction get _mouseButtonMiddleAction =>
      _layerInteractionConfigs.mouseButtonMiddleAction;

  /// Handles a [PointerDownEvent] to update mouse button press states.
  ///
  /// This method should be called from the `onPointerDown` callback
  /// of a [Listener] widget.
  void onPointerDown(PointerDownEvent event) {
    final buttons = event.buttons;

    _isPrimaryMousePressed = (buttons & kPrimaryMouseButton) != 0;
    _isSecondaryMousePressed = (buttons & kSecondaryMouseButton) != 0;
    _isMiddleMousePressed = (buttons & kMiddleMouseButton) != 0;
  }

  /// Handles a [PointerUpEvent] to update mouse button release states.
  ///
  /// This method should be called from the `onPointerUp` callback
  /// of a [Listener] widget.
  void onPointerUp(PointerUpEvent event) {
    final buttons = event.buttons;

    if ((buttons & kPrimaryMouseButton) == 0) {
      _isPrimaryMousePressed = false;
    }
    if ((buttons & kSecondaryMouseButton) == 0) {
      _isSecondaryMousePressed = false;
    }
    if ((buttons & kMiddleMouseButton) == 0) {
      _isMiddleMousePressed = false;
    }
  }

  bool _validateAction(MouseButtonAction action) {
    return (_mouseButtonPrimaryAction == action && isPrimaryMousePressed) ||
        (_mouseButtonSecondaryAction == action && isSecondaryMousePressed) ||
        (_mouseButtonMiddleAction == action && isMiddleMousePressed);
  }

  /// Validates whether the pan action can be performed based on the current
  /// configuration.
  ///
  /// This method checks if zoom functionality is enabled in the main editor
  /// configuration.
  /// If zoom is disabled, the pan action is not allowed and the method
  /// returns `false`.
  /// Otherwise, it delegates the validation to `_validateAction` with the
  /// `MouseButtonAction.pan`.
  ///
  /// Returns `true` if the pan action is valid, otherwise `false`.
  bool validatePanAction() {
    if (!configs.mainEditor.enableZoom) return false;

    return _validateAction(MouseButtonAction.pan);
  }

  /// Validates whether the drag action is allowed based on the current mouse
  /// button action.
  ///
  /// This method checks if the `MouseButtonAction.dragSelect` action is valid
  /// by delegating the validation logic to the `_validateAction` method.
  ///
  /// Returns `true` if the drag action is valid, otherwise `false`.
  bool validateDragAction() {
    return _validateAction(MouseButtonAction.dragSelect);
  }

  /// Validates whether the multi-select action is allowed.
  ///
  /// This method checks if the `MouseButtonAction.multiSelect` action
  /// is valid based on the current state or configuration.
  ///
  /// Returns `true` if the multi-select action is valid, otherwise `false`.
  bool validateMultiSelectAction() {
    return _validateAction(MouseButtonAction.multiSelect);
  }
}
