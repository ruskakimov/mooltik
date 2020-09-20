import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:provider/provider.dart';
import 'package:after_init/after_init.dart';

import '../frame/frame_painter.dart';
import 'easel_gesture_detector.dart';

class Easel extends StatefulWidget {
  Easel({Key key}) : super(key: key);

  @override
  _EaselState createState() => _EaselState();
}

class _EaselState extends State<Easel> with AfterInitMixin<Easel> {
  @override
  void didInitState() {
    final screenSize = MediaQuery.of(context).size;
    context.read<EaselModel>().init(screenSize);
  }

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final frame = context.watch<FrameModel>();

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
      ),
    );
  }
}
