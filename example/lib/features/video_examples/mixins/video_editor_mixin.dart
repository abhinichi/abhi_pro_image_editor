import 'package:flutter/widgets.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:pro_video_editor/pro_video_editor.dart';

/// A mixin for handling video editing states.
mixin VideoEditorMixin<T extends StatefulWidget> on State<T> {
  /// Video editor configuration settings.
  final VideoEditorConfigs videoConfigs = const VideoEditorConfigs(
    initialMuted: true,
    initialPlay: false,
    minTrimDuration: Duration(seconds: 7),
  );

  /// Indicates whether a seek operation is in progress.
  bool isSeeking = false;

  /// Stores the currently selected trim duration span.
  TrimDurationSpan? durationSpan;

  /// Temporarily stores a pending trim duration span.
  TrimDurationSpan? tempDurationSpan;

  /// Controls video playback and trimming functionalities.
  ProVideoController? proVideoController;

  /// Stores generated thumbnails for the trimmer bar and filter background.
  final List<ImageProvider> thumbnails = [];

  /// Holds information about the selected video.
  ///
  /// This will be populated via [setVideoInformations].
  late VideoInformation videoInformation;

  /// Number of thumbnails to generate across the video timeline.
  final int thumbnailCount = 7;

  /// Loads and sets [videoInformation] for the given [video].
  ///
  /// Uses the [VideoUtilsService] to extract metadata such as duration,
  /// resolution, and format.
  Future<void> setVideoInformations(EditorVideo video) async {
    videoInformation =
        await VideoUtilsService.instance.getVideoInformation(video);
  }

  /// Generates thumbnails for the given [video] using calculated timestamps.
  ///
  /// The function computes evenly spaced timestamps based on the video's
  /// duration and the fixed [thumbnailCount]. It also calculates the desired
  /// image width in physical pixels, accounting for the device pixel ratio
  /// and video aspect ratio.
  ///
  /// The resulting thumbnails are added to a local list as [MemoryImage]s.
  Future<void> generateThumbnails(EditorVideo video) async {
    int videoDuration = videoInformation.duration.inMilliseconds;
    int firstPosition = 1000;

    double step = (videoDuration - firstPosition) / (thumbnailCount - 1);

    var timestamps = List.generate(thumbnailCount, (i) {
      return Duration(milliseconds: (step * i).toInt());
    });

    var imageWidth = MediaQuery.sizeOf(context).width /
        thumbnailCount *
        MediaQuery.devicePixelRatioOf(context) *
        videoInformation.resolution.aspectRatio;

    var thumbnailList = await VideoUtilsService.instance
        .createVideoThumbnails(CreateVideoThumbnail(
      video: video,
      timestamps: timestamps,
      imageWidth: imageWidth,
    ));

    thumbnails.addAll(thumbnailList.map(MemoryImage.new));
  }
}
