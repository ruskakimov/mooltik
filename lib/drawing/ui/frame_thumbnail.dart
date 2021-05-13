import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/checkerboard_painter.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
  }) : super(key: key);

  final Frame frame;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: frame.width / frame.height,
        child: CustomPaint(
          painter: CheckerboardPainter(),
          foregroundPainter: FramePainter(frame: frame),
        ),
      ),
    );
  }
}
