import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';
import 'package:mooltik/drawing/ui/reel/frame_menu.dart';
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
  bool _showFramePopup = false;

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
              return _FrameReelItem(
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Icon(FontAwesomeIcons.plus, size: 16),
                ),
                onTap: () async {
                  await reel.appendFrame();
                  scrollTo(reel.frameSeq.length - 1);
                },
              );
            }

            final selected = index == reel.currentIndex;
            final frame = reel.frameSeq[index];

            final item = _FrameReelItem(
              selected: selected,
              child: FrameThumbnail(
                frame: frame,
                background: Colors.transparent,
              ),
              onTap: selected ? _openPopup : () => scrollTo(index),
            );

            return selected ? _wrapWithPopupEntry(item, frame) : item;
          },
        ),
      ),
    );
  }

  Widget _wrapWithPopupEntry(Widget child, Frame selectedFrame) {
    return PopupWithArrowEntry(
      visible: _showFramePopup,
      arrowSide: ArrowSide.bottom,
      arrowSidePosition: ArrowSidePosition.middle,
      arrowAnchor: Alignment(0, -1.1),
      popupColor: Theme.of(context).colorScheme.primary,
      popupBody: FrameMenu(
        selectedFrame: selectedFrame,
        scrollTo: scrollTo,
        jumpTo: jumpTo,
        closePopup: _closePopup,
      ),
      child: child,
      onDragOutside: _closePopup,
      onTapOutside: _closePopup,
    );
  }

  void _openPopup() {
    setState(() {
      _showFramePopup = true;
    });
  }

  void _closePopup() {
    setState(() {
      _showFramePopup = false;
    });
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

  void jumpTo(int frameIndex) {
    final offset = frameOffset(frameIndex);
    print(offset);
    _controller.jumpTo(offset);
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
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);

    return Padding(
      padding: _framePadding,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            foregroundDecoration: selected
                ? BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
          Material(
            type: MaterialType.transparency,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
