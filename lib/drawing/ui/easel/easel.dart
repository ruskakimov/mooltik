import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:provider/provider.dart';

import 'easel_gesture_detector.dart';

class Easel extends StatefulWidget {
  Easel({Key key}) : super(key: key);

  @override
  _EaselState createState() => _EaselState();
}

class _EaselState extends State<Easel> {
  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final frame = context.watch<FrameModel>();
    final onion = context.watch<OnionModel>();

    return LayoutBuilder(builder: (context, constraints) {
      easel.updateSize(constraints.biggest);

      return EaselGestureDetector(
        onStrokeStart: easel.onStrokeStart,
        onStrokeUpdate: easel.onStrokeUpdate,
        onStrokeEnd: easel.onStrokeEnd,
        onStrokeCancel: easel.onStrokeCancel,
        onScaleStart: easel.onScaleStart,
        onScaleUpdate: easel.onScaleUpdate,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.transparent),
            Positioned(
              top: easel.canvasTopOffset,
              left: easel.canvasLeftOffset,
              width: easel.canvasWidth,
              height: easel.canvasHeight,
              child: Transform.rotate(
                alignment: Alignment.topLeft,
                angle: easel.canvasRotation,
                child: RepaintBoundary(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        width: frame.size.width,
                        height: frame.size.height,
                        color: Colors.white,
                      ),
                      if (onion.frameBefore != null)
                        Opacity(
                          opacity: 0.2,
                          child: CustomPaint(
                            size: frame.size,
                            foregroundPainter: FramePainter(
                              frame: onion.frameBefore,
                              background: Colors.transparent,
                              filter: ColorFilter.mode(
                                Colors.red,
                                BlendMode.srcATop,
                              ),
                            ),
                          ),
                        ),
                      if (onion.frameAfter != null)
                        Opacity(
                          opacity: 0.2,
                          child: CustomPaint(
                            size: frame.size,
                            foregroundPainter: FramePainter(
                              frame: onion.frameAfter,
                              background: Colors.transparent,
                              filter: ColorFilter.mode(
                                Colors.green,
                                BlendMode.srcATop,
                              ),
                            ),
                          ),
                        ),
                      CustomPaint(
                        size: frame.size,
                        foregroundPainter: FramePainter(
                          frame: frame,
                          strokes: easel.unrasterizedStrokes,
                          showCursor: true,
                          background: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
