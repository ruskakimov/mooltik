import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/easel/cursor_painter.dart';
import 'package:mooltik/drawing/ui/lasso/lasso_ui_layer.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:mooltik/drawing/data/onion_model.dart';
import 'package:mooltik/drawing/ui/lasso/transformed_image_layer.dart';
import 'package:provider/provider.dart';

import 'easel_gesture_detector.dart';

class Easel extends StatefulWidget {
  Easel({Key? key}) : super(key: key);

  @override
  _EaselState createState() => _EaselState();
}

class _EaselState extends State<Easel> {
  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final onion = context.watch<OnionModel>();
    final reelStack = context.watch<ReelStackModel>();
    final selectedTool = context.watch<ToolboxModel>().selectedTool;

    return LayoutBuilder(builder: (context, constraints) {
      easel.updateSize(constraints.biggest);

      return Stack(
        fit: StackFit.expand,
        children: [
          EaselGestureDetector(
            onStrokeStart: easel.onStrokeStart,
            onStrokeUpdate: easel.onStrokeUpdate,
            onStrokeEnd: easel.onStrokeEnd,
            onStrokeCancel: easel.onStrokeCancel,
            onScaleStart: easel.onScaleStart,
            onScaleUpdate: easel.onScaleUpdate,
            allowDrawingWithFinger: easel.allowDrawingWithFinger,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: easel.canvasTopOffset,
                  left: easel.canvasLeftOffset,
                  width: easel.canvasWidth,
                  height: easel.canvasHeight,
                  child: Transform.rotate(
                    alignment: Alignment.topLeft,
                    angle: easel.canvasRotation,
                    child: EaselCanvas(
                      size: easel.frameSize,
                      frames: reelStack.visibleReels
                          .map((reel) => reel.currentFrame)
                          .toList()
                          .reversed
                          .toList(),
                      activeFrame: easel.frame,
                      beforeActiveFrame: onion.frameBefore,
                      afterActiveFrame: onion.frameAfter,
                      strokes: easel.unrasterizedStrokes,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedTool is Lasso)
            Positioned(
              top: easel.canvasTopOffset,
              left: easel.canvasLeftOffset,
              child: Transform.rotate(
                alignment: Alignment.topLeft,
                angle: easel.canvasRotation,
                child: LassoUiLayer(),
              ),
            ),
        ],
      );
    });
  }
}

class EaselCanvas extends StatelessWidget {
  const EaselCanvas({
    Key? key,
    required this.size,
    required this.frames,
    required this.activeFrame,
    required this.beforeActiveFrame,
    required this.afterActiveFrame,
    required this.strokes,
  }) : super(key: key);

  final Size size;
  final List<Frame> frames;
  final Frame activeFrame;
  final Frame? beforeActiveFrame;
  final Frame? afterActiveFrame;
  final List<Stroke> strokes;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          ..._buildLayers(),
          if (strokes.isNotEmpty) _buildCursor(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
    );
  }

  CustomPaint _buildCursor() {
    return CustomPaint(
      size: size,
      painter: CursorPainter(
        frameSize: size,
        lastStroke: strokes.last,
      ),
    );
  }

  List<Widget> _buildLayers() {
    final layers = <Widget>[];

    for (final frame in frames) {
      if (frame == activeFrame) {
        layers.addAll(_activeLayer(
          frame: frame,
          before: beforeActiveFrame,
          after: afterActiveFrame,
          strokes: strokes,
        ));
      } else {
        layers.add(_inactiveLayer(frame));
      }
    }

    return layers;
  }

  List<Widget> _activeLayer({
    required Frame frame,
    Frame? before,
    Frame? after,
    List<Stroke>? strokes,
  }) {
    return [
      if (before != null)
        CustomPaint(
          isComplex: true,
          size: before.image.size,
          foregroundPainter: FramePainter(
            frame: before,
            filter: ColorFilter.mode(
              Colors.red.withOpacity(0.2),
              BlendMode.srcIn,
            ),
          ),
        ),
      if (after != null)
        CustomPaint(
          isComplex: true,
          size: after.image.size,
          foregroundPainter: FramePainter(
            frame: after,
            filter: ColorFilter.mode(
              Colors.green.withOpacity(0.2),
              BlendMode.srcIn,
            ),
          ),
        ),
      CustomPaint(
        isComplex: true,
        size: frame.image.size,
        foregroundPainter: FramePainter(frame: frame, strokes: strokes),
      ),
      TransformedImageLayer(
        frameSize: frame.image.size,
      ),
    ];
  }

  CustomPaint _inactiveLayer(Frame frame) {
    return CustomPaint(
      isComplex: true,
      size: frame.image.size,
      foregroundPainter: FramePainter(frame: frame),
    );
  }
}
