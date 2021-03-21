import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
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

      return Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: (constraints.maxWidth - itemWidth) / 2,
            ),
            itemCount: timeline.frames.length,
            itemBuilder: (context, index) => _FrameReelItem(
              frame: timeline.frames[index],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: frameWidth,
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );
    });
  }
}

class _FrameReelItem extends StatelessWidget {
  const _FrameReelItem({
    Key key,
    @required this.frame,
  }) : super(key: key);

  final FrameModel frame;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _framePadding,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FrameThumbnail(frame: frame),
          ),
        ),
      ),
    );
  }
}
