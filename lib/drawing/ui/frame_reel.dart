import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/ui/frame_thumbnail.dart';
import 'package:provider/provider.dart';

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

      return _FrameReelItemList(
        key: Key('${context.watch<FrameReelModel>().hashCode}'),
        width: constraints.maxWidth,
        itemWidth: itemWidth,
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
    final reel = context.read<FrameReelModel>();

    _controller = ScrollController(
      initialScrollOffset: frameOffset(reel.currentIndex),
    );
    _controller.addListener(() {
      if (centeredFrameIndex != reel.currentIndex) {
        reel.setCurrent(centeredFrameIndex);
      }
    });
  }

  int get centeredFrameIndex => (_controller.offset / widget.itemWidth).round();

  double frameOffset(int frameIndex) => widget.itemWidth * frameIndex;

  bool get snapped =>
      (_controller.offset - frameOffset(centeredFrameIndex)).abs() < 0.1;

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<FrameReelModel>();

    return GestureDetector(
      // By catching onTapDown gesture, it's possible to keep animateTo from removing user's scroll listener.
      onTapDown: (_) {},
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification && !snapped) {
            scrollTo(centeredFrameIndex);
          }
          return true;
        },
        child: ListView.builder(
          clipBehavior: Clip.none,
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
            left: (widget.width - widget.itemWidth) / 2,
            right: (widget.width - widget.itemWidth) / 2 - widget.itemWidth,
          ),
          primary: false,
          itemCount: reel.frameSeq.length + 1,
          itemExtent: widget.itemWidth,
          itemBuilder: (context, index) {
            if (index == reel.frameSeq.length) {
              return GestureDetector(
                onTap: () async {
                  reel.appendFrame(
                    await context.read<Project>().createNewFrame(),
                  );
                  scrollTo(reel.frameSeq.length - 1);
                },
                child: _FrameReelItem(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Icon(FontAwesomeIcons.plus, size: 16),
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () => scrollTo(index),
              child: _FrameReelItem(
                selected: index == reel.currentIndex,
                child: FrameThumbnail(frame: reel.frameSeq[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  void scrollTo(int frameIndex) {
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        frameOffset(frameIndex),
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
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
    @required this.child,
    this.selected = false,
  }) : super(key: key);

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    return Padding(
      padding: _framePadding,
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.8),
            width: 2,
          ),
          borderRadius: borderRadius,
        ),
        decoration: BoxDecoration(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
