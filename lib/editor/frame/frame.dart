import 'dart:ui';

import 'package:animation_app/editor/gif.dart' show pictureFromFrame;
import 'package:flutter/material.dart' show Colors;

import 'stroke.dart';

class Frame {
  Frame() : _strokes = [];

  final List<Stroke> _strokes;
  Image _raster;
  int _rasterisedUntil = 0;

  double get width => 1280;

  double get height => 720;

  void startPencilStroke(Offset startPoint) {
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = Colors.black,
    ));
  }

  void startEraserStroke(Offset startPoint) {
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.clear,
    ));
  }

  void extendLastStroke(Offset point) {
    _strokes.last.extend(point);
  }

  void cancelLastStroke() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
    }
  }

  Future<void> rasterize() async {
    final pic = pictureFromFrame(this);
    _raster = await pic.toImage(width.toInt(), height.toInt());
    _rasterisedUntil = _strokes.length;
  }

  void clear() {
    _strokes.clear();
  }

  void paintOn(Canvas canvas) {
    canvas.drawColor(Colors.white, BlendMode.srcOver);

    // Save layer to erase paintings on it with `BlendMode.clear`.
    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());

    if (_raster != null) canvas.drawImage(_raster, Offset.zero, Paint());

    for (int i = _rasterisedUntil; i < _strokes.length; i++) {
      _strokes[i].paintOn(canvas);
    }

    // Flatten layer. Combine drawing lines with erasing lines.
    canvas.restore();
  }
}
