import 'package:flutter/material.dart';

abstract class TimeSpan extends ChangeNotifier {
  TimeSpan(Duration duration) : _duration = roundDuration(duration);

  /// Output is set to 50fps, therefore 1 frame = 20 ms.
  static const Duration singleFrameDuration = Duration(milliseconds: 20);

  /// Round duration so that it is a multiple of [singleFrameDuration].
  static Duration roundDuration(Duration duration) {
    final frames =
        (duration.inMilliseconds / singleFrameDuration.inMilliseconds)
            .round()
            .clamp(1, double.infinity);
    return singleFrameDuration * frames;
  }

  Duration get duration => _duration;
  Duration _duration;
  set duration(Duration value) {
    _duration = roundDuration(value);
    notifyListeners();
  }
}
