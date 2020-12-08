import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FrameSliver {
  FrameSliver({
    @required this.startX,
    @required this.endX,
    @required this.thumbnail,
  });

  final double startX;
  final double endX;
  final ui.Image thumbnail;

  void paint(Canvas canvas, double startY, double endY) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(startX, startY, endX, endY).deflate(1),
        Radius.circular(4),
      ),
      Paint()..color = Colors.white,
    );
    canvas.save();
    canvas.translate(startX, startY);
    canvas.scale((endY - startY) / thumbnail.height);
    canvas.drawImage(thumbnail, Offset.zero, Paint());
    canvas.restore();
  }
}
