import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mooltik/common/data/parse_duration.dart';
import 'package:path/path.dart' as p;

class SoundClip {
  SoundClip({
    @required this.file,
    @required Duration startTime,
    Duration duration,
  })  : _startTime = startTime,
        _duration = duration;

  String get path => file.path;
  final File file;

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

  SoundClip.fromJson(Map<String, dynamic> json, String soundDirPath)
      : file = File(p.join(soundDirPath, json['file_name'])),
        _startTime = parseDuration(json['start_time']),
        _duration = parseDuration(json['duration']);

  Map<String, dynamic> toJson() => {
        'file_name': p.basename(file.path),
        'start_time': _startTime.toString(),
        'duration': _duration.toString(),
      };
}
