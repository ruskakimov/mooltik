import 'package:flutter/material.dart';

import 'frame.dart';
import 'frame_painter.dart';
import '../toolbar/tools.dart';

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
  int _fingersOnScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _fingersOnScreen += 1;
      },
      onPointerUp: (e) {
        _fingersOnScreen -= 1;
      },
      onPointerCancel: (e) {
        _fingersOnScreen -= 1;
      },
      child: GestureDetector(
        onPanStart: (DragStartDetails details) {
          if (_fingersOnScreen > 1) return;
          setState(() {
            if (widget.selectedTool == Tool.pencil) {
              widget.frame.startPencilStroke(details.localPosition);
            } else if (widget.selectedTool == Tool.eraser) {
              widget.frame.startEraserStroke(details.localPosition);
            }
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          if (_fingersOnScreen > 1) return;
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
      ),
    );
  }
}
