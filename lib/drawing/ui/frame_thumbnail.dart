import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
    this.background,
  }) : super(key: key);

  final Frame frame;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: frame.width / frame.height,
        child: ColoredBox(
          color: background ??
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          child: CustomPaint(
            isComplex: true,
            foregroundPainter: FramePainter(frame: frame),
          ),
        ),
      ),
    );
  }
}
