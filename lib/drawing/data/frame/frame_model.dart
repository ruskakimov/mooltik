import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

class FrameModel extends ChangeNotifier implements TimeSpan {
  FrameModel({
    int id,
    @required Size size,
    Duration duration = const Duration(seconds: 1),
    ui.Image initialSnapshot,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        _size = size,
        _duration = duration,
        _snapshot = initialSnapshot;

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

  final int id;

  Duration get duration => _duration;
  Duration _duration;
  set duration(Duration value) {
    _duration = roundDuration(value);
    notifyListeners();
  }

  Size get size => _size;
  final Size _size;

  double get width => _size.width;

  double get height => _size.height;

  ui.Image get snapshot => _snapshot;
  ui.Image _snapshot;
  set snapshot(ui.Image snapshot) {
    _snapshot = snapshot;
    notifyListeners();
  }
}
