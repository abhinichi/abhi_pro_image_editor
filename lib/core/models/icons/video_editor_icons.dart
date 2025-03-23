import 'package:flutter/material.dart';

/// Defines icon configurations for the video editor.
class VideoEditorIcons {
  /// Creates an instance of [VideoEditorIcons].
  ///
  /// Provides customizable icons for play, mute, and trim controls.
  const VideoEditorIcons({
    this.playIndicator = Icons.play_arrow_rounded,
    this.muteActive = Icons.volume_off_rounded,
    this.muteInActive = Icons.volume_up_rounded,
    this.trimLeft = Icons.chevron_left,
    this.trimRight = Icons.chevron_right,
  });

  /// Icon displayed when the video is playing.
  final IconData playIndicator;

  /// Icon displayed when the video is muted.
  final IconData muteActive;

  /// Icon displayed when the video is unmuted.
  final IconData muteInActive;

  /// Icon for trimming on the left side.
  final IconData trimLeft;

  /// Icon for trimming on the right side.
  final IconData trimRight;

  /// Creates a copy of this instance with the given parameters overridden.
  VideoEditorIcons copyWith({
    IconData? playIndicator,
    IconData? muteActive,
    IconData? muteInActive,
    IconData? trimLeft,
    IconData? trimRight,
  }) {
    return VideoEditorIcons(
      playIndicator: playIndicator ?? this.playIndicator,
      muteActive: muteActive ?? this.muteActive,
      muteInActive: muteInActive ?? this.muteInActive,
      trimLeft: trimLeft ?? this.trimLeft,
      trimRight: trimRight ?? this.trimRight,
    );
  }
}
