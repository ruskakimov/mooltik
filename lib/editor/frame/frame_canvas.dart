import 'package:flutter/material.dart';

import '../toolbar/tools.dart';
import 'frame_painter.dart';
import 'frame.dart';
import 'canvas_gesture_detector.dart';

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
  Offset _frameOffset = Offset.zero;
  Offset _lastFocal;

  @override
  Widget build(BuildContext context) {
    return CanvasGestureDetector(
      onStrokeStart: (Offset position) {
        setState(() {
          if (widget.selectedTool == Tool.pencil) {
            widget.frame.startPencilStroke(position - _frameOffset);
          } else if (widget.selectedTool == Tool.eraser) {
            widget.frame.startEraserStroke(position - _frameOffset);
          }
        });
      },
      onStrokeUpdate: (Offset position) {
        setState(() {
          widget.frame.extendLastStroke(position - _frameOffset);
        });
      },
      onScaleStart: (ScaleStartDetails details) {
        _lastFocal = details.localFocalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        final diff = details.localFocalPoint - _lastFocal;
        _lastFocal = details.localFocalPoint;

        setState(() {
          _frameOffset += diff;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.transparent),
          Positioned(
            top: _frameOffset.dy,
            left: _frameOffset.dx,
            width: widget.frame.width,
            height: widget.frame.height,
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
