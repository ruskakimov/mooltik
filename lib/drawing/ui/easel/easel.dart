import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/data/reel_stack_model.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/easel/cursor_painter.dart';
import 'package:mooltik/drawing/ui/lasso/lasso_ui_layer.dart';
import 'package:mooltik/drawing/ui/canvas_painter.dart';
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
                      layers: reelStack.visibleReels
                          .map((reel) => reel.currentFrame.image)
                          .toList()
                          .reversed
                          .toList(),
                      active: easel.image,
                      onionBefore: onion.frameBefore?.image,
                      onionAfter: onion.frameAfter?.image,
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
    required this.layers,
    required this.active,
    required this.onionBefore,
    required this.onionAfter,
    required this.strokes,
  }) : super(key: key);

  final Size size;
  final List<DiskImage> layers;
  final DiskImage active;
  final DiskImage? onionBefore;
  final DiskImage? onionAfter;
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
    final finalLayers = <Widget>[];

    for (final frame in layers) {
      if (frame == active) {
        finalLayers.addAll(_activeLayer(
          active: frame,
          before: onionBefore,
          after: onionAfter,
          strokes: strokes,
        ));
      } else {
        finalLayers.add(_inactiveLayer(frame));
      }
    }

    return finalLayers;
  }

  List<Widget> _activeLayer({
    required DiskImage active,
    DiskImage? before,
    DiskImage? after,
    List<Stroke>? strokes,
  }) {
    return [
      if (before != null)
        CustomPaint(
          isComplex: true,
          size: before.size,
          foregroundPainter: CanvasPainter(
            image: before.snapshot,
            filter: ColorFilter.mode(
              Colors.red.withOpacity(0.2),
              BlendMode.srcIn,
            ),
          ),
        ),
      if (after != null)
        CustomPaint(
          isComplex: true,
          size: after.size,
          foregroundPainter: CanvasPainter(
            image: after.snapshot,
            filter: ColorFilter.mode(
              Colors.green.withOpacity(0.2),
              BlendMode.srcIn,
            ),
          ),
        ),
      CustomPaint(
        isComplex: true,
        size: active.size,
        foregroundPainter: CanvasPainter(
          image: active.snapshot,
          strokes: strokes,
        ),
      ),
      TransformedImageLayer(
        frameSize: active.size,
      ),
    ];
  }

  CustomPaint _inactiveLayer(DiskImage image) {
    return CustomPaint(
      isComplex: true,
      size: image.size,
      foregroundPainter: CanvasPainter(image: image.snapshot),
    );
  }
}
