import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/parse_duration.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

class FrameModel extends TimeSpan {
  FrameModel({
    int id,
    @required Size size,
    Duration duration = const Duration(seconds: 1),
    ui.Image initialSnapshot,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        _size = size,
        _snapshot = initialSnapshot,
        super(duration);

  final int id;

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

  factory FrameModel.fromJson(Map<String, dynamic> json, Size frameSize) =>
      FrameModel(
        id: json['id'],
        size: frameSize,
        duration: parseDuration(json['duration']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'duration': duration.toString(),
      };
}
