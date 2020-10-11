import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
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
    final timeline = context.watch<TimelineModel>();

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
                      width: frame.width,
                      height: frame.height,
                      color: Colors.white,
                    ),
                    if (timeline.visibleFrameBefore != null)
                      Opacity(
                        opacity: 0.3,
                        child: CustomPaint(
                          size: Size(frame.width, frame.height),
                          foregroundPainter: FramePainter(
                            frame: timeline.visibleFrameBefore,
                            background: Colors.transparent,
                          ),
                        ),
                      ),
                    if (timeline.visibleFrameAfter != null)
                      Opacity(
                        opacity: 0.1,
                        child: CustomPaint(
                          size: Size(frame.width, frame.height),
                          foregroundPainter: FramePainter(
                            frame: timeline.visibleFrameAfter,
                            background: Colors.transparent,
                          ),
                        ),
                      ),
                    CustomPaint(
                      size: Size(frame.width, frame.height),
                      foregroundPainter: FramePainter(
                        frame: frame,
                        strokes: [
                          if (easel.currentStroke != null) easel.currentStroke,
                        ],
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
  }
}
