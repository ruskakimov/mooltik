import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_painter.dart';
import 'tools.dart';

class FrameCanvas extends StatefulWidget {
  FrameCanvas({
    Key key,
    @required this.frame,
    @required this.selectedTool,
  }) : super(key: key);

  final Frame frame;
  final Tool selectedTool;

  @override
  _FrameCanvasState createState() => _FrameCanvasState();
}

class _FrameCanvasState extends State<FrameCanvas> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          widget.frame.startPaintingStroke(details.localPosition);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          widget.frame.extendLastStroke(details.localPosition);
        });
      },
      child: CustomPaint(
        foregroundPainter: FramePainter(widget.frame),
        child: Container(
          color: Colors.white,
          height: widget.frame.height,
          width: widget.frame.width,
        ),
      ),
    );
  }
}
