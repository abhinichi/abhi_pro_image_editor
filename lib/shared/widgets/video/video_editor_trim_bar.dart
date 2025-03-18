import 'dart:math';

import 'package:flutter/material.dart';

import 'video_editor_configurable.dart';

class VideoEditorTrimBar extends StatefulWidget {
  final double videoDuration;
  final ValueChanged<Duration> onTrimStartChanged;
  final ValueChanged<Duration> onTrimEndChanged;
  final List<ImageProvider> thumbnails; // Thumbnails for preview

  const VideoEditorTrimBar({
    super.key,
    required this.videoDuration,
    required this.onTrimStartChanged,
    required this.onTrimEndChanged,
    required this.thumbnails,
  });

  @override
  _VideoEditorTrimBarState createState() => _VideoEditorTrimBarState();
}

/// TODO: Trimbar zooming
/// TODO: Trimbar move when tap between the bar
/// TODO: Trimbar thumbnails
/// TODO: Trimbar duration text
/// TODO: Trimbar fix duration max issue
class _VideoEditorTrimBarState extends State<VideoEditorTrimBar> {
  double trimStart = 0;
  double trimEnd = 1;

  double get minTrimPercentage =>
      VideoEditorConfigurable.of(context).configs.minTrimDuration.inSeconds /
      widget.videoDuration;

  void _updateTrimStart(double value) {
    setState(() {
      double minEnd = value + minTrimPercentage; // Enforce minimum duration
      trimStart = value;
      trimEnd = max(trimEnd, minEnd); // Prevent end from being too close

      if (trimEnd > 1) {
        trimStart = 1 - minTrimPercentage;
        trimEnd = 1;
      }

      widget.onTrimStartChanged(
          Duration(seconds: (trimStart * widget.videoDuration).toInt()));
    });
  }

  void _updateTrimEnd(double value) {
    setState(() {
      double minStart = value - minTrimPercentage; // Enforce minimum duration
      trimEnd = value;
      trimStart =
          min(trimStart, minStart); // Prevent start from being too close

      if (trimStart < 0) {
        trimStart = 0;
        trimEnd = minTrimPercentage;
      }

      widget.onTrimEndChanged(
          Duration(seconds: (trimEnd * widget.videoDuration).toInt()));
    });
  }

  String _formatTime(double value) {
    int totalSeconds = (value * widget.videoDuration).toInt();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  double get _minInteractiveDimension =>
      Theme.of(context).materialTapTargetSize == MaterialTapTargetSize.padded
          ? kMinInteractiveDimension
          : 0;

  @override
  Widget build(BuildContext context) {
    var player = VideoEditorConfigurable.of(context);

    return player.widgets.trimBar ??
        RepaintBoundary(
          child: LayoutBuilder(builder: (_, constraints) {
            double editorWidth = constraints.maxWidth;
            double trimWidth = (trimEnd - trimStart) * editorWidth;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeText(player, trimStart),
                      _buildTimeText(player, trimEnd),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    // Video Thumbnails
                    Container(
                      height: player.style.trimBarHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 51, 51, 51),
                        borderRadius: BorderRadius.circular(
                            player.style.trimBarHandlerRadius),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.thumbnails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.thumbnails[index],
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(
                                  player.style.trimBarHandlerRadius),
                            ),
                          );
                        },
                      ),
                    ),

                    // Trim selection overlay
                    Positioned(
                      left: trimStart * editorWidth,
                      child: Container(
                        width: trimWidth,
                        height: player.style.trimBarHeight,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: player.style.trimBarBackground, width: 3),
                          borderRadius: BorderRadius.circular(
                              player.style.trimBarHandlerRadius),
                        ),
                      ),
                    ),

                    // Trim handles - Left
                    Positioned(
                      left: trimStart * editorWidth,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragUpdate: (details) {
                          double newValue =
                              trimStart + details.primaryDelta! / editorWidth;
                          if (newValue >= 0 && newValue < trimEnd)
                            _updateTrimStart(newValue);
                        },
                        child: _buildTrimHandle(player, true),
                      ),
                    ),

                    // Trim handles - Right
                    Positioned(
                      left: trimEnd * editorWidth -
                          max(_minInteractiveDimension,
                              player.style.trimBarHandlerWidth),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragUpdate: (details) {
                          double newValue =
                              trimEnd + details.primaryDelta! / editorWidth;
                          if (newValue > trimStart && newValue <= 1)
                            _updateTrimEnd(newValue);
                        },
                        child: _buildTrimHandle(player, false),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
  }

  Widget _buildTimeText(VideoEditorConfigurable player, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: player.style.trimBarTextBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          _formatTime(value),
          style: TextStyle(color: player.style.trimBarTextColor),
        ),
      ),
    );
  }

  Widget _buildTrimHandle(VideoEditorConfigurable player, bool isLeft) {
    ;
    return SizedBox(
      width: max(_minInteractiveDimension, player.style.trimBarHandlerWidth),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          width: player.style.trimBarHandlerWidth,
          height: player.style.trimBarHeight,
          decoration: BoxDecoration(
            color: player.style.trimBarBackground,
            borderRadius: BorderRadius.horizontal(
              left: isLeft
                  ? Radius.circular(player.style.trimBarHandlerRadius)
                  : Radius.zero,
              right: isLeft
                  ? Radius.zero
                  : Radius.circular(player.style.trimBarHandlerRadius),
            ),
          ),
          child: Center(
            child: Icon(
              isLeft ? player.icons.trimLeft : player.icons.trimRight,
              color: player.style.trimBarColor,
              size: player.style.trimBarHandlerIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
