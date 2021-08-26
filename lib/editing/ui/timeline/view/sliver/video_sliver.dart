import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';

typedef ThumbnailAt = CompositeImage Function(double x);

class VideoSliver extends Sliver {
  VideoSliver({
    required Rect area,
    required this.thumbnailAt,
  }) : super(area);

  /// Image at a given X coordinate.
  final ThumbnailAt thumbnailAt;

  @override
  void paint(Canvas canvas) {
    canvas.drawRRect(rrect, Paint()..color = Colors.white);

    canvas.save();
    canvas.clipRRect(rrect);

    for (var x = area.left; x < area.right; x += area.height) {
      // Separator.
      canvas.drawLine(
        Offset(x, area.top),
        Offset(x, area.bottom),
        Paint()..strokeWidth = 0.5,
      );

      _paintCenteredThumbnail(
        canvas,
        thumbnailAt(x),
        Rect.fromLTRB(x, area.top, x + area.height, area.bottom),
      );
    }

    canvas.restore();
  }

  void _paintCenteredThumbnail(
    Canvas canvas,
    CompositeImage thumbnail,
    Rect paintArea,
  ) {
    canvas.save();
    canvas.clipRect(paintArea);
    canvas.translate(paintArea.left, paintArea.top);
    final scaleFactor = paintArea.height / thumbnail.height;
    canvas.scale(scaleFactor);

    final centeringOffset = Offset(
      -thumbnail.width / 2 + paintArea.width / scaleFactor / 2,
      0,
    );

    canvas.drawCompositeImage(
      thumbnail,
      centeringOffset,
      Paint(),
    );

    canvas.restore();
  }
}
