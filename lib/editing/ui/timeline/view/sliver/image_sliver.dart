import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

class ImageSliver extends Sliver {
  ImageSliver({
    @required double startX,
    @required double endX,
    @required this.thumbnail,
    @required this.index,
    this.opacity = 1,
  }) : super(startX, endX);

  final ui.Image thumbnail;
  final int index;
  final double opacity;

  @override
  void paint(Canvas canvas, double startY, double endY) {
    final rrect = getRrect(startY, endY);
    final paint = Paint()..color = Colors.white.withOpacity(opacity);

    canvas.drawRRect(rrect, paint);

    if (thumbnail != null) {
      canvas.save();
      canvas.clipRRect(rrect);
      canvas.translate(startX, startY);
      final double scaleFactor = (endY - startY) / thumbnail.height;
      canvas.scale(scaleFactor);

      final sliverWidth = rrect.width / scaleFactor;

      if (thumbnail.width > sliverWidth) {
        // Center thumbnail if it overflows sliver.
        final xOffset = (sliverWidth - thumbnail.width) / 2;
        canvas.drawImage(thumbnail, Offset(xOffset, 0), paint);
      } else {
        // Repeat thumbnails until overflow.
        for (double xOffset = 0;
            xOffset < sliverWidth;
            xOffset += thumbnail.width) {
          canvas.drawImage(thumbnail, Offset(xOffset, 0), paint);
        }
      }

      canvas.restore();
    }
  }
}
