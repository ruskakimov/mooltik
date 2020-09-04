import 'dart:math';

import 'package:flutter/material.dart';

import '../toolbar/tools.dart';
import 'frame_painter.dart';
import 'frame.dart';
import 'canvas_gesture_detector.dart';

const twoPi = pi * 2;

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

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale = 1;
  double _prevScale = 1;

  Offset _fixedFramePoint;

  Offset toFramePoint(Offset point) {
    final p = (point - _offset) / _scale;
    return Offset(
      p.dx * cos(_rotation) + p.dy * sin(_rotation),
      -p.dx * sin(_rotation) + p.dy * cos(_rotation),
    );
  }

  Offset calcOffsetToMatchPoints(Offset framePoint, Offset screenPoint) {
    final a = screenPoint.dx;
    final b = screenPoint.dy;
    final c = framePoint.dx;
    final d = framePoint.dy;
    final si = sin(_rotation);
    final co = cos(_rotation);
    final ta = si / co;
    final s = _scale;

    final e = -d * s - a * si + b * co;
    final f = -c * s + a * co + b * si;

    final x = (f - e * ta) / (co + si * ta);
    final y = (e + x * si) / co;

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return CanvasGestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _prevScale = _scale;
        _prevRotation = _rotation;
        _fixedFramePoint = toFramePoint(details.localFocalPoint);

        if (widget.selectedTool == Tool.pencil) {
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
        setState(() {
          final framePoint = toFramePoint(details.localPosition);
          widget.frame.extendLastStroke(framePoint);
        });
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _prevScale * details.scale;
          _rotation = (_prevRotation + details.rotation) % twoPi;
          _offset = calcOffsetToMatchPoints(
              _fixedFramePoint, details.localFocalPoint);
        });
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
            child: Transform.rotate(
              alignment: Alignment.topLeft,
              angle: _rotation,
              child: RepaintBoundary(
                child: CustomPaint(
                  foregroundPainter: FramePainter(widget.frame),
                  child: Container(
                    color: Colors.white,
                    height: widget.frame.height,
                    width: widget.frame.width,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
