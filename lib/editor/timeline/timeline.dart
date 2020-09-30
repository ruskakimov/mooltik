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

    final keyframes = context.watch<TimelineModel>().keyframes;
    final thumbnailSize = Size(
      150,
      150 / keyframes.first.width * keyframes.first.height,
    );

    return ListWheelScrollView(
      physics: BouncingScrollPhysics(),
      itemExtent: thumbnailSize.height,
      children: [
        for (var frame in keyframes)
          FrameThumbnail(frame: frame, size: thumbnailSize)
      ],
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
