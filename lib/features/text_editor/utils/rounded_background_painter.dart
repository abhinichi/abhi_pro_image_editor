import 'dart:math';

import 'package:flutter/material.dart';

import '../models/line_metrics_model.dart';

/// A [CustomPainter] that paints text with a rounded background, optional
/// padding, and an optional cursor indicator.
///
/// This painter is useful for rendering styled text with enhanced visual
/// elements such as rounded corners, background color, and hit-testing
/// support. It can also reserve space for a cursor, making it suitable for
/// both static and interactive text UIs.
class RoundedBackgroundTextPainter extends CustomPainter {
  /// Creates a [RoundedBackgroundTextPainter] that paints text with a rounded
  /// background.
  const RoundedBackgroundTextPainter({
    required this.backgroundColor,
    required this.painter,
    this.innerRadius = 8.0,
    this.outerRadius = 10.0,
    required this.onHitTestResult,
    required this.horizontalPadding,
    required this.textAlign,
    required this.textDirection,
    this.cursorWidth = 0.0,
  });

  /// Callback function triggered with the result of a hit test on the text
  /// area.
  final Function(bool hasHit)? onHitTestResult;

  /// The background color used to paint the rounded background behind the text.
  final Color backgroundColor;

  /// The [TextPainter] used to layout and paint the text.
  final TextPainter painter;

  /// Determines how the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The text direction used to resolve [TextAlign.start] and [TextAlign.end].
  final TextDirection textDirection;

  /// The width of the text cursor (if shown).
  final double cursorWidth;

  /// Horizontal padding around the text, inside the background shape.
  final double horizontalPadding;

  /// The radius used for rounding the corners of the inner background shape.
  final double innerRadius;

  /// The radius used for rounding the corners of the outer background shape.
  final double outerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final metrics = this.painter.computeLineMetrics();
    if (metrics.isEmpty) return;

    final painter = Paint()..color = backgroundColor;
    final path = Path();
    final cornerPath = Path();
    double endY = 0;

    double maxWidth = 0;
    EdgeInsets outsidePadding = EdgeInsets.zero;
    final bool isLeftAlign = textAlign == TextAlign.left ||
        (textAlign == TextAlign.start && textDirection == TextDirection.ltr);
    final bool isRightAlign = textAlign == TextAlign.right ||
        (textAlign == TextAlign.end && textDirection == TextDirection.rtl);

    bool isCenterAlign =
        textAlign == TextAlign.center || textAlign == TextAlign.justify;

    final helpers = metrics.map((lineMetric) {
      return LineMetricsModel(
        metrics: lineMetric,
        length: metrics.length,
        textAlign: textAlign,
        cursorWidth: cursorWidth,
      );
    }).toList();

    double? firstMaximalWidth;

    for (int index = 0; index < helpers.length; index++) {
      final info = helpers[index];
      if (info.isEmpty) continue;

      final double paddingHorizontal = info.rawHeight * 0.3;
      final double paddingVertical = info.rawHeight * 0.1;
      final double radius = info.innerRadius(innerRadius);

      final bool hasNoLineBefore = index == 0 || helpers[index - 1].isEmpty;
      final bool hasNoLineAfter =
          index == helpers.length - 1 || helpers[index + 1].isEmpty;

      void connectSimilarLineWidth() {
        final maxLineDifference = radius * (isCenterAlign ? 4 : 2);

        bool shouldConnect(int index) {
          if (index >= helpers.length - 1) return false;

          final currentLine = helpers[index];
          final nextLine = helpers[index + 1];

          /// Check first if it's necessary to calculate the minimum width
          double lineDifference = currentLine.rawWidth - nextLine.rawWidth;
          bool shouldConnect = lineDifference.abs() < maxLineDifference;
          return shouldConnect;
        }

        if (!shouldConnect(index)) return;

        double minimumWidth = info.rawWidth;
        double minimumX = info.x;
        int endIndex = index;

        /// Find the minimum required width
        for (var i = index; i < helpers.length; i++) {
          final helper = helpers[i];
          if (helper.rawWidth > minimumWidth) {
            minimumWidth = helper.rawWidth;
            minimumX = helper.x;
          }
          if (!shouldConnect(i)) {
            endIndex = i;
            break;
          }
        }

        /// Apply changes
        for (var i = index; i <= endIndex; i++) {
          helpers[i]
            ..overrideX = minimumX
            ..overrideWidth = minimumWidth;

          if (i == index) {
            helpers[i]
              ..roundBottomLeft = false
              ..roundBottomRight = false;
          }
          if (i == endIndex) {
            helpers[i]
              ..roundTopLeft = false
              ..roundTopRight = false;
          }
        }
      }

      if (!hasNoLineAfter && !info.isOverriden) connectSimilarLineWidth();

      bool roundTopRight =
          (!isRightAlign || hasNoLineBefore) && info.roundTopRight;
      bool roundTopLeft =
          (!isLeftAlign || hasNoLineBefore) && info.roundTopLeft;
      bool roundBottomRight =
          (!isRightAlign || hasNoLineAfter) && info.roundBottomRight;
      bool roundBottomLeft =
          (!isLeftAlign || hasNoLineAfter) && info.roundBottomLeft;

      final double startX = info.startX - paddingHorizontal;
      late final double endX;
      if (isRightAlign) {
        firstMaximalWidth ??= info.endX + paddingHorizontal;
        endX = firstMaximalWidth;
      } else {
        endX = info.endX + paddingHorizontal;
      }

      final double startY = info.startY - paddingVertical;
      final double endY = info.endY + paddingVertical;

      void generateBackgroundRectangle() {
        path
          ..moveTo(startX + (roundTopLeft ? radius : 0), startY)

          /// Top-Right edge
          ..lineTo(endX - radius, startY);
        if (roundTopRight) {
          path.arcToPoint(
            Offset(endX, startY + radius),
            radius: Radius.circular(radius),
          );
        } else {
          path.lineTo(endX, startY);
        }

        /// Bottom-Right edge
        path.lineTo(endX, endY - (roundBottomRight ? radius : 0));
        if (roundBottomRight) {
          path.arcToPoint(
            Offset(endX - radius, endY),
            radius: Radius.circular(radius),
          );
        } else {
          path.lineTo(endX - radius, endY);
        }

        /// Bottom edge
        path.lineTo(startX + (roundBottomLeft ? radius : 0), endY);
        if (roundBottomLeft) {
          path.arcToPoint(
            Offset(startX, endY - radius),
            radius: Radius.circular(radius),
          );
        } else {
          path.lineTo(startX, endY);
        }

        /// Left edge
        path.lineTo(startX, startY + (roundTopLeft ? radius : 0));
        if (roundTopLeft) {
          path.arcToPoint(
            Offset(startX + radius, startY),
            radius: Radius.circular(radius),
          );
        } else {
          path.lineTo(startX, startY);
        }

        path.close();
      }

      double calculateAdaptiveRadius() {
        final lineBefore = helpers[index - 1];

        double lineDifference = (info.rawWidth - lineBefore.rawWidth).abs();

        if (textAlign == TextAlign.center) {
          lineDifference /= 4;
        } else {
          lineDifference /= 2;
        }

        return min(radius, lineDifference);
      }

      void drawInnerRoundingPath({
        required Offset from,
        required double lineToX,
        required Offset arcEnd,
        required double radius,
        required bool clockwise,
      }) {
        final radiusC = Radius.circular(radius);

        cornerPath
          ..moveTo(from.dx, from.dy)
          ..lineTo(lineToX, from.dy)
          ..arcToPoint(arcEnd, radius: radiusC, clockwise: clockwise)
          ..moveTo(from.dx, from.dy)
          ..lineTo(lineToX, from.dy)
          ..arcToPoint(arcEnd,
              radius: radiusC, clockwise: clockwise, largeArc: true)
          ..close();
      }

      void drawInnerRoundingLeft() {
        final lineBefore = helpers[index - 1];
        if (lineBefore.isEmpty) return;

        final beforeStartX = lineBefore.startX - paddingHorizontal;
        final beforeY = lineBefore.endY + paddingVertical;
        final startX = info.startX - paddingHorizontal;
        final r = calculateAdaptiveRadius();

        if (info.rawWidth > lineBefore.rawWidth) {
          drawInnerRoundingPath(
            from: Offset(beforeStartX, startY),
            lineToX: beforeStartX - r,
            arcEnd: Offset(beforeStartX, startY - r),
            radius: r,
            clockwise: false,
          );
        } else {
          drawInnerRoundingPath(
            from: Offset(startX, beforeY),
            lineToX: startX - r,
            arcEnd: Offset(startX, beforeY + r),
            radius: r,
            clockwise: true,
          );
        }
      }

      void drawInnerRoundingRight() {
        final lineBefore = helpers[index - 1];
        if (lineBefore.isEmpty) return;

        final beforeEndX = lineBefore.endX + paddingHorizontal;
        final beforeY = lineBefore.endY + paddingVertical;
        final endX = info.endX + paddingHorizontal;
        final r = calculateAdaptiveRadius();

        if (info.rawWidth > lineBefore.rawWidth) {
          drawInnerRoundingPath(
            from: Offset(beforeEndX, startY),
            lineToX: beforeEndX + r,
            arcEnd: Offset(beforeEndX, startY - r),
            radius: r,
            clockwise: true,
          );
        } else {
          drawInnerRoundingPath(
            from: Offset(endX, beforeY),
            lineToX: endX + r,
            arcEnd: Offset(endX, beforeY + r),
            radius: r,
            clockwise: false,
          );
        }
      }

      generateBackgroundRectangle();

      if (!hasNoLineBefore) {
        if (!isLeftAlign) drawInnerRoundingLeft();
        if (!isRightAlign) drawInnerRoundingRight();
      }
    }

    /// Close all outside holes where the text align.
    switch (textAlign) {
      case TextAlign.right:
        canvas.drawRect(
          Rect.fromLTRB(
            maxWidth - outsidePadding.left,
            outsidePadding.top,
            maxWidth,
            endY - outsidePadding.vertical,
          ),
          painter,
        );
        break;
      case TextAlign.left:
        canvas.drawRect(
          Rect.fromLTRB(
            -outsidePadding.left,
            outsidePadding.top,
            0,
            endY - outsidePadding.vertical,
          ),
          painter,
        );
        break;
      default:
    }

    canvas.drawPath(
      Path.combine(PathOperation.union, path, cornerPath),
      painter,
    );
    this.painter.paint(canvas, Offset(horizontalPadding, 0.0));
  }

  @override
  bool shouldRepaint(covariant RoundedBackgroundTextPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.painter.width != painter.width ||
        oldDelegate.painter.height != painter.height ||
        oldDelegate.painter.ellipsis != painter.ellipsis ||
        oldDelegate.painter.plainText != painter.plainText ||
        oldDelegate.painter.textAlign != painter.textAlign ||
        oldDelegate.painter.preferredLineHeight !=
            painter.preferredLineHeight ||
        oldDelegate.innerRadius != innerRadius ||
        oldDelegate.textAlign != textAlign ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.outerRadius != outerRadius;
  }

  @override
  bool? hitTest(Offset position) {
    // Retrieve the line information
    /* FIXME: final lineInfos = computeLines(text, textAlign);

    // Check each line
  for (final lineInfo in lineInfos) {
      for (final info in lineInfo) {
        // Construct the rounded rectangle for this line
        final rRect = _getRRect(info);

        // Check if the position is within this rectangle
        if (rRect.contains(position)) {
          onHitTestResult?.call(true);
          return true;
        }
      }
    } */

    // If the position was not within any line's bounding box
    onHitTestResult?.call(false);
    return false;
  }
}
