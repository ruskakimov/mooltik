import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mooltik/common/parse_duration.dart';

class SoundClip {
  SoundClip({
    @required this.file,
    @required Duration startTime,
    Duration duration,
  })  : _startTime = startTime,
        _duration = duration;

  String get path => file.path;
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

  SoundClip.fromJson(Map<String, dynamic> json)
      : file = File(json['path']),
        _startTime = parseDuration(json['start_time']),
        _duration = parseDuration(json['duration']);

  Map<String, dynamic> toJson() => {
        'path': file.path,
        'start_time': _startTime.toString(),
        'duration': _duration.toString(),
      };
}
