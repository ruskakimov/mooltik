import 'dart:io';

import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:path/path.dart' as p;

class SoundClip {
  SoundClip({
    required this.file,
    required Duration startTime,
    required Duration duration,
  })  : _startTime = startTime,
        _duration = duration;

  String get path => file.path;
  final File file;

  Duration get startTime => _startTime;
  Duration _startTime;

  Duration get endTime => _startTime + _duration;

  Duration get duration => _duration;
  Duration _duration;

  factory SoundClip.fromJson(Map<String, dynamic> json, String soundDirPath) =>
      SoundClip(
        file: File(p.join(soundDirPath, json[_fileNameKey])),
        startTime: (json[_startTimeKey] as String).parseDuration(),
        duration: (json[_durationKey] as String).parseDuration(),
      );

  Map<String, dynamic> toJson() => {
        _fileNameKey: p.basename(file.path),
        _startTimeKey: _startTime.toString(),
        _durationKey: _duration.toString(),
      };
}

const String _fileNameKey = 'file_name';
const String _startTimeKey = 'start_time';
const String _durationKey = 'duration';
