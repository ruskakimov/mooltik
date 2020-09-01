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
  Offset _offset = Offset.zero;
  double _scale = 1;
  double _prevScale = 1;

  Offset toFramePoint(Offset point) => (point - _offset) / _scale;

  @override
  Widget build(BuildContext context) {
    return CanvasGestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        if (widget.selectedTool == Tool.hand) {
          _prevScale = _scale;
        } else if (widget.selectedTool == Tool.pencil) {
          final framePoint = toFramePoint(details.localFocalPoint);
          setState(() {
            widget.frame.startPencilStroke(framePoint);
          });
        } else if (widget.selectedTool == Tool.eraser) {
          final framePoint = toFramePoint(details.localFocalPoint);
          setState(() {
            widget.frame.startEraserStroke(framePoint);
          });
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (widget.selectedTool == Tool.hand) {
          setState(() {
            _offset += details.delta;
          });
        } else {
          setState(() {
            final framePoint = toFramePoint(details.localPosition);
            widget.frame.extendLastStroke(framePoint);
          });
        }
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        if (widget.selectedTool == Tool.hand) {
          final newScale = _prevScale * details.scale;
          setState(() {
            _offset = details.localFocalPoint -
                toFramePoint(details.localFocalPoint) * newScale;
            _scale = newScale;
          });
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.transparent),
          Positioned(
            top: _offset.dy,
            left: _offset.dx,
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
