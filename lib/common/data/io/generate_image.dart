import 'dart:ui';

import 'package:flutter/material.dart' show CustomPainter;

Future<Image> generateImage(
  CustomPainter? painter,
  int width,
  int height,
) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  painter?.paint(canvas, Size(width.toDouble(), height.toDouble()));
  final picture = recorder.endRecording();
  return picture.toImage(width, height);
}
