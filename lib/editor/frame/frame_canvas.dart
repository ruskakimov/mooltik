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
  Offset _offset;

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale;
  double _prevScale;

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
      onStrokeStart: (DragStartDetails details) {
        if (widget.selectedTool == Tool.pencil) {
          final framePoint = toFramePoint(details.localPosition);
          setState(() {
            widget.frame.startPencilStroke(framePoint);
          });
        } else if (widget.selectedTool == Tool.eraser) {
          final framePoint = toFramePoint(details.localPosition);
          setState(() {
            widget.frame.startEraserStroke(framePoint);
          });
        }
      },
      onStrokeUpdate: (DragUpdateDetails details) {
        setState(() {
          final framePoint = toFramePoint(details.localPosition);
          widget.frame.extendLastStroke(framePoint);
        });
      },
      onStrokeEnd: () async {
        widget.frame.finishLastStroke();
        await widget.frame.rasterize();
        setState(() {});
      },
      onStrokeCancel: () {
        setState(() {
          widget.frame.cancelLastStroke();
        });
      },
      onScaleStart: (ScaleStartDetails details) {
        _prevScale = _scale;
        _prevRotation = _rotation;
        _fixedFramePoint = toFramePoint(details.localFocalPoint);
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = (_prevScale * details.scale).clamp(0.1, 8.0);
          _rotation = (_prevRotation + details.rotation) % twoPi;
          _offset = calcOffsetToMatchPoints(
              _fixedFramePoint, details.localFocalPoint);
        });
      },
      child: LayoutBuilder(builder: (context, constraints) {
        _scale ??= constraints.maxWidth / widget.frame.width;
        _offset ??= Offset(
          0,
          (constraints.maxHeight - widget.frame.height * _scale) / 2,
        );

        return Stack(
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
        );
      }),
    );
  }
}
