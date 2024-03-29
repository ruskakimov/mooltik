import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_image.dart';

class CompositeImagePainter extends CustomPainter {
  CompositeImagePainter(this.image);

  final CompositeImage image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );
    canvas.scale(size.width / image.width, size.height / image.height);

    canvas.drawCompositeImage(
      image,
      Offset.zero,
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(CompositeImagePainter oldDelegate) =>
      image != oldDelegate.image;

  @override
  bool shouldRebuildSemantics(CompositeImagePainter oldDelegate) => false;
}
