import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../toolbar/tools.dart';
import 'frame_painter.dart';
import 'frame.dart';
import 'easel_gesture_detector.dart';

const twoPi = pi * 2;

class Easel extends StatefulWidget {
  Easel({
    Key key,
    @required this.selectedTool,
  }) : super(key: key);

  final Tool selectedTool;

  @override
  _EaselState createState() => _EaselState();
}

class _EaselState extends State<Easel> {
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
    final frame = context.watch<Frame>();

    return EaselGestureDetector(
      onStrokeStart: (DragStartDetails details) {
        if (widget.selectedTool == Tool.pencil) {
          final framePoint = toFramePoint(details.localPosition);
          frame.startStroke(
            framePoint,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..color = Colors.black
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
          );
        } else if (widget.selectedTool == Tool.eraser) {
          final framePoint = toFramePoint(details.localPosition);
          frame.startStroke(
            framePoint,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 20
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..blendMode = BlendMode.clear,
          );
        }
      },
      onStrokeUpdate: (DragUpdateDetails details) {
        final framePoint = toFramePoint(details.localPosition);
        frame.extendLastStroke(framePoint);
      },
      onStrokeEnd: () {
        frame.finishLastStroke();
      },
      onStrokeCancel: () {
        frame.cancelLastStroke();
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
        _scale ??= constraints.maxWidth / frame.width;
        _offset ??= Offset(
          0,
          (constraints.maxHeight - frame.height * _scale) / 2,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.transparent),
            Positioned(
              top: _offset.dy,
              left: _offset.dx,
              width: frame.width * _scale,
              height: frame.height * _scale,
              child: Transform.rotate(
                alignment: Alignment.topLeft,
                angle: _rotation,
                child: RepaintBoundary(
                  child: CustomPaint(
                    foregroundPainter: FramePainter(frame),
                    child: Container(
                      color: Colors.white,
                      height: frame.height,
                      width: frame.width,
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
