import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_painter.dart';

class FrameCanvas extends StatefulWidget {
  FrameCanvas({Key key}) : super(key: key);

  @override
  _FrameCanvasState createState() => _FrameCanvasState();
}

class _FrameCanvasState extends State<FrameCanvas> {
  final frame = Frame();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          frame.startStroke(details.localPosition);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          frame.extendLastStroke(details.localPosition);
        });
      },
      child: ClipRect(
        child: CustomPaint(
          foregroundPainter: FramePainter(frame),
          child: Container(
            color: Colors.white,
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
  }
}
