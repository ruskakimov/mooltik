import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';
import 'package:provider/provider.dart';

import '../frame/frame_painter.dart';
import '../frame/frame_model.dart';
import 'easel_gesture_detector.dart';

class Easel extends StatefulWidget {
  Easel({Key key}) : super(key: key);

  @override
  _EaselState createState() => _EaselState();
}

class _EaselState extends State<Easel> {
  @override
  Widget build(BuildContext context) {
    final selectedTool = context.watch<ToolboxModel>().selectedTool;
    final frame = context.watch<FrameModel>();
    final easel = context.watch<EaselModel>();

    return EaselGestureDetector(
      onStrokeStart: (DragStartDetails details) {
        final framePoint = easel.toFramePoint(details.localPosition);
        frame.startStroke(framePoint, selectedTool.paint);
      },
      onStrokeUpdate: (DragUpdateDetails details) {
        final framePoint = easel.toFramePoint(details.localPosition);
        frame.extendLastStroke(framePoint);
      },
      onStrokeEnd: () {
        frame.finishLastStroke();
      },
      onStrokeCancel: () {
        frame.cancelLastStroke();
      },
      onScaleStart: easel.onScaleStart,
      onScaleUpdate: easel.onScaleUpdate,
      child: LayoutBuilder(builder: (context, constraints) {
        easel.scale ??= constraints.maxWidth / frame.width;
        easel.offset ??= Offset(
          0,
          (constraints.maxHeight - frame.height * easel.scale) / 2,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.transparent),
            Positioned(
              top: easel.offset.dy,
              left: easel.offset.dx,
              width: frame.width * easel.scale,
              height: frame.height * easel.scale,
              child: Transform.rotate(
                alignment: Alignment.topLeft,
                angle: easel.rotation,
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
