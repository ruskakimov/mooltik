import 'package:flutter/material.dart';

import '../toolbar/tools.dart';
import 'frame_painter.dart';
import 'frame.dart';
import 'single_pointer_pan_detector.dart';

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
    return SinglePointerPanDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          if (widget.selectedTool == Tool.pencil) {
            widget.frame.startPencilStroke(details.localPosition);
          } else if (widget.selectedTool == Tool.eraser) {
            widget.frame.startEraserStroke(details.localPosition);
          }
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          widget.frame.extendLastStroke(details.localPosition);
        });
      },
      child: Stack(
        children: [
          Positioned(
            child: CustomPaint(
              foregroundPainter: FramePainter(widget.frame),
              child: Container(
                color: Colors.white,
                height: widget.frame.height,
                width: widget.frame.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
