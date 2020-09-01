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
  double _scale = 1;
  double _prevScale = 1;
  Offset _lastFocal;

  @override
  Widget build(BuildContext context) {
    return CanvasGestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        if (widget.selectedTool == Tool.hand) {
          _lastFocal = details.localFocalPoint;
          _prevScale = _scale;
        } else if (widget.selectedTool == Tool.pencil) {
          setState(() {
            widget.frame
                .startPencilStroke(details.localFocalPoint - _frameOffset);
          });
        } else if (widget.selectedTool == Tool.eraser) {
          setState(() {
            widget.frame
                .startEraserStroke(details.localFocalPoint - _frameOffset);
          });
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (widget.selectedTool == Tool.hand) {
          setState(() {
            _frameOffset += details.delta;
          });
        } else {
          setState(() {
            widget.frame.extendLastStroke(details.localPosition - _frameOffset);
          });
        }
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        if (widget.selectedTool == Tool.hand) {
          final diff = details.localFocalPoint - _lastFocal;
          _lastFocal = details.localFocalPoint;

          setState(() {
            _frameOffset += diff;
            _scale = _prevScale * details.scale;
          });
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.transparent),
          Positioned(
            top: _frameOffset.dy,
            left: _frameOffset.dx,
            width: widget.frame.width * _scale,
            height: widget.frame.height * _scale,
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
