import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/base_image.dart';
import 'package:mooltik/drawing/ui/painted_glass.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

class ImageSliver extends Sliver {
  ImageSliver({
    required Rect area,
    required this.image,
    this.ghost = false,
  }) : super(area);

  final BaseImage image;
  final bool ghost;

  @override
  void paint(Canvas canvas) {
    final opacity = ghost ? 0.3 : 1.0;

    final backgroundColor =
        frostedGlassColor.withOpacity(frostedGlassColor.opacity * opacity);
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);

    _paintThumbnail(canvas, opacity);
  }

  void _paintThumbnail(Canvas canvas, double opacity) {
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.translate(area.left, area.top);
    final double scaleFactor = area.height / image.height;
    canvas.scale(scaleFactor);

    final sliverWidth = rrect.width / scaleFactor;
    final paint = Paint()..color = Colors.black.withOpacity(opacity);

    if (image.width.toDouble() > sliverWidth) {
      // Center thumbnail if it overflows sliver.
      final xOffset = (sliverWidth - image.width) / 2;
      image.draw(canvas, Offset(xOffset, 0), paint);
    } else {
      // Repeat thumbnails until overflow.
      for (double xOffset = 0; xOffset < sliverWidth; xOffset += image.width) {
        image.draw(canvas, Offset(xOffset, 0), paint);
      }
    }

    canvas.restore();
  }
}
