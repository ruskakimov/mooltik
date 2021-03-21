import 'package:flutter/material.dart';
import 'package:mooltik/editing/ui/preview/frame_thumbnail.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/data/timeline_model.dart';

const _framePadding = const EdgeInsets.only(
  left: 4.0,
  right: 4.0,
  bottom: 8.0,
);

class FrameReel extends StatelessWidget {
  const FrameReel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final frameHeight = constraints.maxHeight - _framePadding.vertical;
      final frameWidth = frameHeight / 9 * 16;
      final itemWidth = frameWidth + _framePadding.horizontal;

      final timeline = context.watch<TimelineModel>();

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: (constraints.maxWidth - itemWidth) / 2,
        ),
        itemCount: timeline.frames.length,
        itemBuilder: (context, index) => Padding(
          padding: _framePadding,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FrameThumbnail(frame: timeline.frames[index]),
          ),
        ),
      );
    });
  }
}
