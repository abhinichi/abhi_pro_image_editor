import 'package:flutter/widgets.dart';

class VideoEditorStyle {
  const VideoEditorStyle({
    this.playIndicatorColor = const Color(0xFFFFFFFF),
    this.playIndicatorBackground = const Color.fromARGB(128, 0, 0, 0),
    this.muteButtonColor = const Color(0xFFFFFFFF),
    this.muteButtonBackground = const Color.fromARGB(60, 0, 0, 0),
    this.infoBannerTextStyle,
    this.infoBannerTextColor = const Color(0xFFFFFFFF),
    this.infoBannerBackground = const Color.fromARGB(60, 0, 0, 0),
    this.trimBarTextColor = const Color(0xFFFFFFFF),
    this.trimBarTextBackground = const Color.fromARGB(60, 0, 0, 0),
    this.trimBarColor = const Color(0xFFFFFFFF),
    this.trimBarBackground = const Color(0xFF0f7dff),
    this.trimBarHandlerIconSize = 24,
    this.trimBarHeight = 50,
    this.trimBarHandlerWidth = 20,
    this.trimBarHandlerRadius = 5,
  });

  final Color playIndicatorColor;
  final Color playIndicatorBackground;

  final Color muteButtonColor;
  final Color muteButtonBackground;

  final TextStyle? infoBannerTextStyle;
  final Color infoBannerTextColor;
  final Color infoBannerBackground;

  final Color trimBarTextColor;
  final Color trimBarTextBackground;

  final Color trimBarColor;
  final Color trimBarBackground;
  final double trimBarHeight;

  final double trimBarHandlerWidth;
  final double trimBarHandlerIconSize;
  final double trimBarHandlerRadius;

  /// TODO: write copyWith method
}
