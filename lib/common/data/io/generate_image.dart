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
  final image = await picture.toImage(width, height);
  picture.dispose();
  return image;
}

Future<Image> generateEmptyImage(int width, int height) =>
    generateImage(null, width, height);
