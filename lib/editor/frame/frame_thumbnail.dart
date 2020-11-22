import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.frame,
  }) : super(key: key);

  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: CustomPaint(
            size: Size(
              constraints.maxHeight / frame.height * frame.width,
              constraints.maxHeight,
            ),
            painter: FramePainter(frame: frame),
          ),
        );
      },
    );
  }
}
