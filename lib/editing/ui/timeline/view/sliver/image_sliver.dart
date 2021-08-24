import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/frame_window.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

class ImageSliver extends Sliver {
  ImageSliver({
    required Rect area,
    required this.thumbnail,
    this.ghost = false,
  }) : super(area);

  final ui.Image? thumbnail;
  final bool ghost;

  @override
  void paint(Canvas canvas) {
    final opacity = ghost ? 0.3 : 1.0;

    final backgroundColor =
        frostedGlassColor.withOpacity(frostedGlassColor.opacity * opacity);
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);

    if (thumbnail != null) _paintThumbnail(canvas, opacity);
  }

  void _paintThumbnail(Canvas canvas, double opacity) {
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.translate(area.left, area.top);
    final double scaleFactor = area.height / thumbnail!.height;
    canvas.scale(scaleFactor);

    final sliverWidth = rrect.width / scaleFactor;
    final paint = Paint()..color = Colors.black.withOpacity(opacity);

    if (thumbnail!.width > sliverWidth) {
      // Center thumbnail if it overflows sliver.
      final xOffset = (sliverWidth - thumbnail!.width) / 2;
      canvas.drawImage(thumbnail!, Offset(xOffset, 0), paint);
    } else {
      // Repeat thumbnails until overflow.
      for (double xOffset = 0;
          xOffset < sliverWidth;
          xOffset += thumbnail!.width) {
        canvas.drawImage(thumbnail!, Offset(xOffset, 0), paint);
      }
    }

    canvas.restore();
  }
}
