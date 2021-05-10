import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
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
                        width: easel.frameSize.width,
                        height: easel.frameSize.height,
                        color: Colors.white,
                      ),
                      ..._buildLayers(easel),
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

  List<Widget> _buildLayers(EaselModel easel) {
    final frames = context
        .read<ReelStackModel>()
        .reels
        .map((reel) => reel.currentFrame)
        .toList()
        .reversed;
    final onion = context.read<OnionModel>();
    final layers = <Widget>[];

    for (final frame in frames) {
      if (frame == easel.frame) {
        layers.addAll(_activeLayer(
          frame: frame,
          before: onion.frameBefore,
          after: onion.frameAfter,
          strokes: easel.unrasterizedStrokes,
        ));
      } else {
        layers.add(_inactiveLayer(frame));
      }
    }

    return layers;
  }

  List<Widget> _activeLayer({
    Frame frame,
    Frame before,
    Frame after,
    List<Stroke> strokes,
  }) {
    return [
      if (before != null)
        Opacity(
          opacity: 0.2,
          child: CustomPaint(
            size: before.size,
            foregroundPainter: FramePainter(
              frame: before,
              background: Colors.transparent,
              filter: ColorFilter.mode(
                Colors.red,
                BlendMode.srcATop,
              ),
            ),
          ),
        ),
      if (after != null)
        Opacity(
          opacity: 0.2,
          child: CustomPaint(
            size: after.size,
            foregroundPainter: FramePainter(
              frame: after,
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
          strokes: strokes,
          showCursor: true,
          background: Colors.transparent,
        ),
      ),
    ];
  }

  CustomPaint _inactiveLayer(Frame frame) {
    return CustomPaint(
      size: frame.size,
      foregroundPainter: FramePainter(
        frame: frame,
        background: Colors.transparent,
      ),
    );
  }
}
