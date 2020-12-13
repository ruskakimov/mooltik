import 'dart:math';
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

  RRect _getRrect(double startY, double endY) => RRect.fromRectAndRadius(
        Rect.fromLTRB(startX, startY, endX, endY).deflate(1),
        Radius.circular(4),
      );

  void paint(Canvas canvas, double startY, double endY) {
    final RRect rrect = _getRrect(startY, endY);
    canvas.drawRRect(rrect, Paint()..color = Colors.white);
    if (thumbnail != null) {
      canvas.save();
      canvas.clipRRect(rrect);
      canvas.translate(startX, startY);
      final double scaleFactor = (endY - startY) / thumbnail.height;
      canvas.scale(scaleFactor);
      final double xOverflow = max(
        0,
        thumbnail.width - rrect.width / scaleFactor,
      );
      canvas.drawImage(thumbnail, Offset(-xOverflow / 2, 0), Paint());
      canvas.restore();
    }
  }
}
