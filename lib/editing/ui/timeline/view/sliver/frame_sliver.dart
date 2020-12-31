import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

class FrameSliver extends Sliver {
  FrameSliver({
    @required double startX,
    @required double endX,
    @required this.thumbnail,
    @required this.frameIndex,
  }) : super(startX, endX);

  final ui.Image thumbnail;
  final int frameIndex;

  @override
  void paint(Canvas canvas, double startY, double endY) {
    final RRect rrect = getRrect(startY, endY);
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
