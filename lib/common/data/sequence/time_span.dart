import 'package:mooltik/common/data/project/fps_config.dart';

abstract class TimeSpan {
  TimeSpan(Duration duration) : _duration = roundDurationToFrames(duration);

  /// Round duration so that it is a multiple of [singleFrameDuration].
  static Duration roundDurationToFrames(Duration duration) {
    final frames =
        (duration.inMicroseconds / singleFrameDuration.inMicroseconds)
            .round()
            .clamp(1, double.infinity);
    return singleFrameDuration * frames;
  }

  /// Ceils duration so that it is a multiple of [singleFrameDuration].
  static Duration ceilDurationToFrames(Duration duration) {
    final frames =
        (duration.inMicroseconds / singleFrameDuration.inMicroseconds)
            .ceil()
            .clamp(1, double.infinity);
    return singleFrameDuration * frames;
  }

  Duration get duration => _duration;
  final Duration _duration;

  TimeSpan copyWith({Duration? duration});
}
