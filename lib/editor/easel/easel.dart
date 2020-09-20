import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:provider/provider.dart';

import '../frame/frame_painter.dart';
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

    return EaselGestureDetector(
      onStrokeStart: easel.onStrokeStart,
      onStrokeUpdate: easel.onStrokeUpdate,
      onStrokeEnd: easel.onStrokeEnd,
      onStrokeCancel: easel.onStrokeCancel,
      onScaleStart: easel.onScaleStart,
      onScaleUpdate: easel.onScaleUpdate,
      child: LayoutBuilder(builder: (context, constraints) {
        easel.updateEaselArea(constraints.maxWidth, constraints.maxHeight);

        return Stack(
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
                  child: CustomPaint(
                    foregroundPainter: FramePainter(easel.frame),
                    child: Container(
                      color: Colors.white,
                      height: easel.frame.height,
                      width: easel.frame.width,
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
