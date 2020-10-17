import 'package:flutter/material.dart';
import 'package:mooltik/editor/easel/easel_model.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

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
    final reel = context.watch<ReelModel>();
    final toolbox = context.watch<ToolboxModel>();

    return ChangeNotifierProxyProvider2<ReelModel, ToolboxModel, EaselModel>(
      create: (_) => EaselModel(
        frame: reel.selectedFrame,
        // TODO: Pass frame width/height from a single source.
        frameWidth: reel.selectedFrame.width,
        frameHeight: reel.selectedFrame.height,
        selectedTool: toolbox.selectedTool,
        createFrame: reel.createFrameInSelectedSlot,
        screenSize: MediaQuery.of(context).size,
      ),
      update: (_, reel, toolbox, easel) => easel
        ..updateFrame(reel.selectedFrame)
        ..updateSelectedTool(toolbox.selectedTool)
        ..updateSelectedColor(toolbox.selectedColor),
      builder: (context, child) {
        final easel = context.watch<EaselModel>();
        final frame = context.watch<FrameModel>();
        final reel = context.watch<ReelModel>();

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
                        if (reel.visibleFrameBefore != null)
                          Opacity(
                            opacity: 0.2,
                            child: CustomPaint(
                              size: Size(frame.width, frame.height),
                              foregroundPainter: FramePainter(
                                frame: reel.visibleFrameBefore,
                                background: Colors.transparent,
                                filter: ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcATop,
                                ),
                              ),
                            ),
                          ),
                        if (reel.visibleFrameAfter != null)
                          Opacity(
                            opacity: 0.2,
                            child: CustomPaint(
                              size: Size(frame.width, frame.height),
                              foregroundPainter: FramePainter(
                                frame: reel.visibleFrameAfter,
                                background: Colors.transparent,
                                filter: ColorFilter.mode(
                                  Colors.green,
                                  BlendMode.srcATop,
                                ),
                              ),
                            ),
                          ),
                        CustomPaint(
                          size: Size(frame.width, frame.height),
                          foregroundPainter: FramePainter(
                            frame: frame,
                            strokes: [
                              if (easel.currentStroke != null)
                                easel.currentStroke,
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
      },
    );
  }
}
