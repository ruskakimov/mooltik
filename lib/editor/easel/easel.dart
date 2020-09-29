import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
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
      onStrokeStart: timeline.playing ? null : easel.onStrokeStart,
      onStrokeUpdate: timeline.playing ? null : easel.onStrokeUpdate,
      onStrokeEnd: timeline.playing ? null : easel.onStrokeEnd,
      onStrokeCancel: timeline.playing ? null : easel.onStrokeCancel,
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
                  foregroundPainter: FramePainter(
                    frame,
                    strokes: [easel.currentStroke],
                  ),
                  child: Container(
                    color: Colors.white,
                    height: frame.height,
                    width: frame.width,
                  ),
                ),
              ),
            ),
          ),
          if (frame.undoAvailable)
            Positioned(
              top: 0,
              left: 56,
              child: EaselIconButton(
                icon: FontAwesomeIcons.undo,
                onTap: frame.undo,
              ),
            ),
          if (frame.redoAvailable)
            Positioned(
              top: 0,
              right: 56,
              child: EaselIconButton(
                icon: FontAwesomeIcons.redo,
                onTap: frame.redo,
              ),
            ),
        ],
      ),
    );
  }
}

class EaselIconButton extends StatelessWidget {
  const EaselIconButton({
    Key key,
    @required this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(2, 2),
          child: Icon(
            icon,
            color: Colors.black26,
          ),
        ),
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: onTap,
        ),
      ],
    );
  }
}
