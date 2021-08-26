import 'dart:io';

import 'package:mooltik/common/data/extensions/duration_methods.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:path/path.dart' as p;

class SoundClip extends TimeSpan {
  SoundClip({
    required this.file,
    required Duration startTime,
    required Duration duration,
  })  : _startTime = startTime,
        super(duration);

  String get path => file.path;
  final File file;

  Duration get startTime => _startTime;
  Duration _startTime;

  Duration get endTime => _startTime + duration;

  factory SoundClip.fromJson(Map<String, dynamic> json, String soundDirPath) =>
      SoundClip(
        file: File(p.join(soundDirPath, json[_fileNameKey])),
        startTime: (json[_startTimeKey] as String).parseDuration(),
        duration: (json[_durationKey] as String).parseDuration(),
      );

  Map<String, dynamic> toJson() => {
        _fileNameKey: p.basename(file.path),
        _startTimeKey: _startTime.toString(),
        _durationKey: duration.toString(),
      };

  @override
  SoundClip copyWith({Duration? duration}) => SoundClip(
        file: file,
        startTime: startTime,
        duration: duration ?? this.duration,
      );

  @override
  void dispose() {}
}

const String _fileNameKey = 'file_name';
const String _startTimeKey = 'start_time';
const String _durationKey = 'duration';
