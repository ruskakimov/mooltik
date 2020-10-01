import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Update when selected frame is painted on.
    context.watch<FrameModel>();

    final timeline = context.watch<TimelineModel>();
    final keyframes = timeline.keyframes;
    final thumbnailSize = Size(
      150,
      150 / keyframes.first.width * keyframes.first.height,
    );

    return CupertinoPicker.builder(
      useMagnifier: false,
      diameterRatio: 2,
      squeeze: 1,
      onSelectedItemChanged: timeline.selectFrame,
      itemExtent: thumbnailSize.height,
      childCount: keyframes.length,
      itemBuilder: (context, index) => FrameThumbnail(
        frame: keyframes[index],
        size: thumbnailSize,
      ),
    );
  }
}

class FrameThumbnail extends StatelessWidget {
  const FrameThumbnail({
    Key key,
    @required this.size,
    @required this.frame,
  }) : super(key: key);

  final Size size;
  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: FramePainter(frame),
    );
  }
}
