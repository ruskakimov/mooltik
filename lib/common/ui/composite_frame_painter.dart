import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';

class CompositeFramePainter extends CustomPainter {
  CompositeFramePainter(this.frame);

  final CompositeFrame frame;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.srcOver);
    canvas.scale(size.width / frame.width, size.height / frame.height);

    canvas.drawCompositeImage(
      frame.compositeImage,
      Offset.zero,
      Paint()..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(CompositeFramePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CompositeFramePainter oldDelegate) => false;
}
