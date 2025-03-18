import 'package:flutter/material.dart';

class VideoEditorIcons {
  const VideoEditorIcons({
    this.playIndicator = Icons.play_arrow_rounded,
    this.muteActive = Icons.volume_off_rounded,
    this.muteInActive = Icons.volume_up_rounded,
    this.trimLeft = Icons.chevron_left,
    this.trimRight = Icons.chevron_right,
  });

  final IconData playIndicator;
  final IconData muteActive;
  final IconData muteInActive;
  final IconData trimLeft;
  final IconData trimRight;

  /// TODO: write copyWith method
}
