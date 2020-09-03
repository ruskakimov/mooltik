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
          _scale = _prevScale * details.scale; // s
          _rotation = (_prevRotation + details.rotation) % twoPi; // r

          // _offset = details.localFocalPoint - _fixedFramePoint * _scale; // o

          // p = (fp - o) / s;
          //
          // px = (fpx - ox) / s
          // py = (fpy - oy) / s
          //
          // ffpx = (fpx - ox) / s * cos(r) + (fpy - oy) / s * sin(r)
          // ffpy = -(fpx - ox) / s * sin(r) + (fpy - oy) / s * cos(r)
          //
          // ffpx = (fpx - ox) / s * cos(r) + (fpy - oy) / s * sin(r)
          // ffpy = (ox - fpx) / s * sin(r) + (fpy - oy) / s * cos(r)
          //
          // ffpy * s = (ox - fpx) * sin(r) + (fpy - oy) * cos(r)
          // ffpx * s = (fpx - ox) * cos(r) + (fpy - oy) * sin(r)
          //
          // ffpy*s = ox*sin(r) - fpx*sin(r) + (fpy - oy)*cos(r)
          // ffpx*s = (fpx - ox)*cos(r) + fpy*sin(r) - oy*sin(r)
          //
          // ffpy*s = X*sin(r) - fpx*sin(r) + fpy*cos(r) - Y*cos(r)
          // ffpx*s = fpx*cos(r) - X*cos(r) + fpy*sin(r) - Y*sin(r)
          //
          // ffpy*s = X*sin(r) - fpx*sin(r) + fpy*cos(r) - Y*cos(r)
          // ffpx*s = fpx*cos(r) - X*cos(r) + fpy*sin(r) - Y*sin(r)
          //
          // Y*cos(r) - X*sin(r) = -ffpy*s - fpx*sin(r) + fpy*cos(r)
          // X*cos(r) + Y*sin(r) = -ffpx*s + fpx*cos(r)  + fpy*sin(r)
          //
          // Y*cos(r) - X*sin(r) = -ffpy*s - fpx*sin(r) + fpy*cos(r)
          // X*cos(r) + Y*sin(r) = -ffpx*s + fpx*cos(r)  + fpy*sin(r)
          //
          // Y*cos(r) - X*sin(r) = -ffpy*s - fpx*sin(r) + fpy*cos(r)
          // X*cos(r) + Y*sin(r) = -ffpx*s + fpx*cos(r) + fpy*sin(r)
          //
          // Y*cos(r) - X*sin(r) = E
          // X*cos(r) + Y*sin(r) = F
          //
          // Y = (E + X*sin(r)) / cos(r)
          // X*cos(r) + (E + X*sin(r)) / cos(r) * sin(r) = F
          // X*cos(r) + E/cos(r)*sin(r) + X*sin2(r)/cos(r) = F
          // X * (cos(r) + sin2(r)/cos(r)) = F - E/cos(r)*sin(r)
          // X = (F - E/cos(r)*sin(r)) / (cos(r) + sin2(r)/cos(r))

          final a = details.localFocalPoint.dx;
          final b = details.localFocalPoint.dy;
          final c = _fixedFramePoint.dx;
          final d = _fixedFramePoint.dy;
          final si = sin(_rotation);
          final co = cos(_rotation);
          final ta = si / co;
          final s = _scale;

          final e =
              -d * s - a * si + b * co; //-ffpy*s - fpx*sin(r) + fpy*cos(r)
          final f =
              -c * s + a * co + b * si; //-ffpx*s + fpx*cos(r) + fpy*sin(r)

          final x = (f - e / co * si) /
              (co +
                  si *
                      si /
                      co); //(F - E/cos(r)*sin(r)) / (cos(r) + sin2(r)/cos(r))
          final y = (e + x * si) / co; // (E + X*sin(r)) / cos(r)

          // final y = (c - a + b * ta) * si - c * s * ta + b * co - d * s;
          // final x = c + b * ta - y * ta - c * s / co;

          _offset = Offset(x, y);

          // FIND o!

          // fp = details.localFocalPoint

          // p.x * cos(r) + p.y * sin(r) == ffp.x
          // -p.x * sin(r) + p.y * cos(r) == ffp.y

          // p = (fp - o) / s

          // p.x = (fp.x - o.x) / s
          // p.y = (fp.y - o.y) / s

          // (fp.x - o.x) / s * cos(r) + (fp.y - o.y) / s * sin(r) == ffp.x
          // -(fp.x - o.x) / s * sin(r) + (fp.y - o.y) / s * cos(r) == ffp.y

          // (fp.x - o.x) * cos(r) + (fp.y - o.y) * sin(r) == ffp.x * s
          // -(fp.x - o.x) * sin(r) + (fp.y - o.y) * cos(r) == ffp.y * s

          // (fp.x - o.x) * cos(r) + (fp.y - o.y) * sin(r) == ffp.x * s
          // -(fp.x - o.x) * sin(r) + (fp.y - o.y) * cos(r) == ffp.y * s

          // (fp.x - o.x) * cos(r) + (fp.y - o.y) * sin(r) == ffp.x * s
          // (o.x - fp.x) * sin(r) + (fp.y - o.y) * cos(r) == ffp.y * s

          // (fp.x - o.x) * cos(r) + (fp.y - o.y) * sin(r) == ffp.x * s
          // (o.x - fp.x) * sin(r) + (fp.y - o.y) * cos(r) == ffp.y * s

          // fp.x * cos(r) - o.x * cos(r) + fp.y * sin(r) - o.y * sin(r) == ffp.x * s
          // o.x * sin(r) - fp.x * sin(r) + fp.y * cos(r) - o.y * cos(r) == ffp.y * s

          //   fp.x * cos(r) - o.x * cos(r) + fp.y * sin(r) - o.y * sin(r) == ffp.x * s
          // - fp.x * sin(r) + o.x * sin(r) + fp.y * cos(r) - o.y * cos(r) == ffp.y * s

          //   fp.x * cos(r) - o.x * cos(r) + fp.y * sin(r) - o.y * sin(r) == ffp.x * s
          // - fp.x * sin(r) + o.x * sin(r) + fp.y * cos(r) - o.y * cos(r) == ffp.y * s
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
