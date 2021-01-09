import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FrameModel extends ChangeNotifier {
  FrameModel({
    int id,
    @required Size size,
    Duration duration = const Duration(seconds: 1),
    ui.Image initialSnapshot,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        _size = size,
        _duration = duration,
        _snapshot = initialSnapshot;

  final int id;

  Duration get duration => _duration;
  Duration _duration;
  set duration(Duration value) {
    if (value <= Duration.zero) return;
    _duration = value;
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
