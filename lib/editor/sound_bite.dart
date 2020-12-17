import 'dart:io';

import 'package:flutter/foundation.dart';

class SoundBite {
  SoundBite({
    @required this.file,
    @required Duration offset,
    Duration duration,
  })  : _offset = offset,
        _duration = duration;

  String get uri => file.path;
  final File file;

  // final Uint8List waveform;

  Duration get offset => _offset;
  Duration _offset;

  Duration get duration => _duration;
  Duration _duration;
}
