import 'dart:ui';

import 'package:flutter/widgets.dart';
import '/core/models/editor_configs/paint_editor/censor_configs.dart';

/// A widget that applies a blur effect to a specific area.
///
/// This widget uses [BackdropFilter] to blur its child. It supports both
/// rectangular and circular blur areas, depending on the `enableRoundArea`
/// property of the provided [CensorConfigs].
///
/// The size of the blurred area can be specified using the `size` parameter.
/// If `size` is `null`, it will expand to fill the available space.
/// ```
class BlurAreaItem extends StatelessWidget {
  /// Creates a [BlurAreaItem].
  ///
  /// - [censorConfigs] defines the blur intensity and shape.
  /// - [size] defines the width and height of the blurred area.
  ///   If `null`, the widget will expand to fill the available space.
  const BlurAreaItem({
    super.key,
    required this.censorConfigs,
    this.size,
  });

  /// The size of the blur area. If `null`, the widget expands to fit its
  /// parent.
  final Size? size;

  /// Configuration for blur intensity and shape.
  final CensorConfigs censorConfigs;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _buildClipper(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: censorConfigs.blurSigmaX,
            sigmaY: censorConfigs.blurSigmaY,
          ),
          child: _buildArea(),
        ),
      ),
    );
  }

  Widget _buildClipper({required Widget child}) {
    if (censorConfigs.enableRoundArea) {
      return ClipOval(child: child);
    }
    return ClipRRect(child: child);
  }

  Widget _buildArea() {
    if (size != null) {
      return SizedBox(width: size!.width, height: size!.height);
    }
    return const SizedBox.expand();
  }
}
