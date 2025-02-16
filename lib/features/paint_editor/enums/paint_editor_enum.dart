/// The `PaintMode` enum represents different paint-item modes for a drawing
/// application in Flutter.
enum PaintMode {
  /// Allows to move and zoom the editor
  moveAndZoom,

  /// Allows freehand drawing.
  freeStyle,

  /// Draws a straight line between two points.
  line,

  /// Creates a rectangle shape.
  rect,

  /// Draws a line with an arrowhead at the end point.
  arrow,

  /// Creates a circle shape starting from a point.
  circle,

  /// Draws a dashed line between two points.
  dashLine,

  /// Remove paint-items when hit.
  eraser,

  /// Creates a rectangle which blurs the background.
  blur,

  // TODO: Write documentation after implementing pixelate mode.

  /// This mode is currently **not available** and serves as a placeholder for
  /// future implementations.
  pixelate,
}
