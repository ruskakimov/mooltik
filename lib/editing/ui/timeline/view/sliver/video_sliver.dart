import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

typedef ThumbnailAt = ui.Image Function(double x);

class VideoSliver extends Sliver {
  VideoSliver({
    @required Rect area,
    @required this.thumbnailAt,
    @required int index,
  }) : super(area, index);

  /// Image at a given X coordinate.
  final ThumbnailAt thumbnailAt;

  @override
  void paint(Canvas canvas) {
    canvas.drawRRect(rrect, Paint()..color = Colors.white);

    final firstThumbnail = thumbnailAt(area.left);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.translate(area.left, area.top);
    final double scaleFactor = area.height / firstThumbnail.height;
    canvas.scale(scaleFactor);

    for (var x = area.left; x < area.right; x += area.height) {
      final thumbnail = thumbnailAt(x);
      final thumbnailStart = (x - area.left) / scaleFactor;
      final availableWidth = area.height / scaleFactor;
      final centeringOffset = -thumbnail.width / 2 + availableWidth / 2;
      canvas.drawImage(
        thumbnail,
        Offset(thumbnailStart + centeringOffset, 0),
        Paint(),
      );

      // Separator.
      canvas.drawLine(
        Offset(thumbnailStart, 0),
        Offset(thumbnailStart, thumbnail.height.toDouble()),
        Paint()..strokeWidth = 0.5 / scaleFactor,
      );
    }

    canvas.restore();
  }
}
