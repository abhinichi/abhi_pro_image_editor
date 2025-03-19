import '../video/trim_duration_span_model.dart';

class VideoEditorCallbacks {
  VideoEditorCallbacks({
    this.onPlay,
    this.onPause,
    this.onMuteToggle,
    this.onTrimSpanUpdate,
    this.onTrimSpanEnd,
  });
  final Function()? onPlay;
  final Function()? onPause;
  final Function(bool isMuted)? onMuteToggle;
  final Function(TrimDurationSpan durationSpan)? onTrimSpanUpdate;
  final Function(TrimDurationSpan durationSpan)? onTrimSpanEnd;
}
