import 'dart:io';

import 'package:flutter/foundation.dart';

class SoundBite {
  SoundBite({
    @required this.file,
    @required Duration startTime,
    Duration duration,
  })  : _startTime = startTime,
        _duration = duration;

  String get uri => file.path;
  final File file;

  // final Uint8List waveform;

  Duration get startTime => _startTime;
  Duration _startTime;

  Duration get duration => _duration;
  Duration _duration;

  SoundBite copyWith({Duration duration}) => SoundBite(
        file: file,
        startTime: startTime,
        duration: duration ?? this.duration,
      );
}
