import 'package:flutter/material.dart';

import '/core/models/editor_configs/video_editor_configs.dart';
import '/shared/widgets/video/video_editor_mute_button.dart';
import '/shared/widgets/video/video_editor_state_widget.dart';
import 'video_editor_configurable.dart';
import 'video_editor_info_banner.dart';
import 'video_editor_trim_bar.dart';

class VideoEditorControlsWidget extends StatelessWidget {
  const VideoEditorControlsWidget();

  @override
  Widget build(BuildContext context) {
    var player = VideoEditorConfigurable.of(context);

    bool alignTop =
        player.configs.controlsPosition == VideoEditorControlPosition.top;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Stack(
        children: [
          player.widgets.headerToolbar ??
              Column(
                spacing: 10,
                verticalDirection:
                    alignTop ? VerticalDirection.down : VerticalDirection.up,
                children: [
                  VideoEditorTrimBar(
                    videoDuration: 120, // Video duration in seconds
                    thumbnails: [],
                    onTrimStartChanged: (duration) {
                      print('Trim Start: ${duration.inSeconds}s');
                    },
                    onTrimEndChanged: (duration) {
                      print('Trim End: ${duration.inSeconds}s');
                    },
                  ),
                  const Row(
                    spacing: 12,
                    children: [
                      VideoEditorMuteButton(),
                      VideoEditorInfoBanner(),
                    ],
                  ),
                ],
              ),
          const VideoEditorStateWidget(),
        ],
      ),
    );
  }
}
