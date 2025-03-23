import 'package:flutter/material.dart';
import '/shared/controllers/video_controller.dart';
import '/shared/extensions/duration_extension.dart';
import '/shared/extensions/int_extension.dart';
import '/shared/widgets/video/video_editor_configurable.dart';

/// Displays an informational banner in the video editor.
///
/// This widget shows the selected trim duration and the estimated
/// file size based on the trimmed portion.
class VideoEditorInfoBanner extends StatelessWidget {
  /// Creates a [VideoEditorInfoBanner] widget.
  const VideoEditorInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    var player = VideoEditorConfigurable.of(context);
    ProVideoController controller = player.controller;

    return ValueListenableBuilder(
      valueListenable: controller.trimDurationSpanNotifier,
      builder: (_, durationSpan, __) {
        // If a custom info banner widget is provided, use it
        if (player.configs.widgets.infoBanner != null) {
          return player.configs.widgets.infoBanner!(durationSpan);
        }

        // Calculate estimated file size based on trimmed duration
        int estimatedFileSize = (controller.fileSize /
                controller.videoDuration.inSeconds *
                durationSpan.duration.inSeconds)
            .round();

        return IgnorePointer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: player.style.infoBannerBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${durationSpan.duration.toTimeString()} | '
              '${estimatedFileSize.toBytesString(1)}',
              style: player.style.infoBannerTextStyle ??
                  TextStyle(
                    fontSize: 14,
                    color: player.style.infoBannerTextColor,
                  ),
            ),
          ),
        );
      },
    );
  }
}
