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

      return Stack(
        children: [
          _FrameReelItemList(
            width: constraints.maxWidth,
            itemWidth: itemWidth,
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

class _FrameReelItemList extends StatefulWidget {
  const _FrameReelItemList({
    Key key,
    @required this.width,
    @required this.itemWidth,
  }) : super(key: key);

  final double width;
  final double itemWidth;

  @override
  __FrameReelItemListState createState() => __FrameReelItemListState();
}

class __FrameReelItemListState extends State<_FrameReelItemList> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final timeline = context.read<TimelineModel>();
    _controller = ScrollController(
      initialScrollOffset: frameOffset(timeline.currentFrameIndex),
    );
    _controller.addListener(() {
      if (centeredFrameIndex < timeline.currentFrameIndex) {
        timeline.stepBackward();
      } else if (centeredFrameIndex > timeline.currentFrameIndex) {
        timeline.stepForward();
      }
    });
  }

  int get centeredFrameIndex => (_controller.offset / widget.itemWidth).round();

  double frameOffset(int frameIndex) => widget.itemWidth * frameIndex;

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    return GestureDetector(
      // By catching onTapDown gesture, it's possible to keep animateTo from removing user's scroll listener.
      onTapDown: (_) {},
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              scrollTo(centeredFrameIndex);
            });
          }
          return true;
        },
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: (widget.width - widget.itemWidth) / 2,
          ),
          primary: false,
          itemCount: timeline.frames.length,
          itemExtent: widget.itemWidth,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => scrollTo(index),
            child: _FrameReelItem(
              frame: timeline.frames[index],
            ),
          ),
        ),
      ),
    );
  }

  void scrollTo(int frameIndex) {
    _controller.animateTo(
      frameOffset(frameIndex),
      duration: Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
