import 'package:flutter/widgets.dart';
import '/shared/widgets/video/video_editor_configurable.dart';

/// Displays a thumbnail preview of the video trim selection.
///
/// This widget shows a series of generated thumbnails representing
/// different frames of the trimmed video section.
class VideoEditorTrimThumbnailBar extends StatelessWidget {
  /// Creates a [VideoEditorTrimThumbnailBar] widget.
  const VideoEditorTrimThumbnailBar({super.key});

  @override
  Widget build(BuildContext context) {
    var player = VideoEditorConfigurable.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: player.style.trimBarHeight,
      decoration: BoxDecoration(
        gradient: player.style.trimBarGradientBackground,
        borderRadius: BorderRadius.circular(player.style.trimBarHandlerRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: player.controller.thumbnails.map((item) {
          return Expanded(
            child: Image(
              image: item,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }
}
