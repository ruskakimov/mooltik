import 'dart:io';

import 'package:flutter/foundation.dart';

class SoundClip {
  SoundClip({
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

  Duration get endTime => _startTime + _duration;

  Duration get duration => _duration;
  Duration _duration;

  SoundClip copyWith({Duration duration}) => SoundClip(
        file: file,
        startTime: startTime,
        duration: duration ?? this.duration,
      );
}
