import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/reel/reel_model.dart';

import 'frame_thumbnail.dart';

const thumbnailSize = Size(112, 64);
const durationModeScrollUnit = 24.0;

class ReelDrawer extends StatefulWidget {
  const ReelDrawer({
    Key key,
    this.open,
  }) : super(key: key);

  final bool open;

  @override
  _ReelDrawerState createState() => _ReelDrawerState();
}

class _ReelDrawerState extends State<ReelDrawer> {
  ScrollController controller;
  bool _pinned = false;
  double _draggedInDurationMode = 0;

  ReelModel get reel => context.read<ReelModel>();

  int get selectedId => (controller.offset / thumbnailSize.height).round();

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: reel.selectedFrameId * thumbnailSize.height,
    )..addListener(_onScroll);
  }

  void _onScroll() {
    reel.selectFrame(selectedId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller.hasClients &&
        selectedId != reel.selectedFrameId &&
        !reel.playing) {
      controller.removeListener(_onScroll);
      _scrollTo(reel.selectedFrameId);
      controller.addListener(_onScroll);
    }
  }

  void _scrollTo(int index) {
    controller.animateTo(
      index * thumbnailSize.height,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update when selected frame is painted on.
    context.watch<FrameModel>();

    final reel = context.watch<ReelModel>();

    return AnimatedLeftDrawer(
      width: thumbnailSize.width,
      open: widget.open,
      child: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              final padding =
                  (constraints.maxHeight - thumbnailSize.height) / 2;
              final lastIndex = reel.frames.length - 1;

              final before = SizedBox(height: padding);
              final after = SizedBox(
                height: padding,
                child: Column(
                  children: [
                    SizedBox(
                      height: thumbnailSize.height,
                      child: AppIconButton(
                        icon: FontAwesomeIcons.plusCircle,
                        onTap: () {
                          reel.addFrame();
                          if (_pinned) {
                            setState(() {
                              _pinned = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );

              return ListView.builder(
                itemBuilder: (context, index) {
                  final selected = index == reel.selectedFrameId;
                  return Column(
                    children: [
                      if (index == 0) before,
                      GestureDetector(
                        onTap: () {
                          _scrollTo(index);
                        },
                        onHorizontalDragEnd: (dragDetails) {
                          final toLeft =
                              dragDetails.velocity.pixelsPerSecond.dx < 0;
                          if (toLeft) {
                            // Swiped to left.
                            reel.deleteFrameAt(index);
                          } else {
                            // Swiped to right.
                            reel.createOrRestoreFrameAt(index);
                          }
                        },
                        child: Transform.scale(
                          scale: 0.99,
                          child: FrameThumbnail(
                            frame: reel.frames[index],
                            size: thumbnailSize,
                            selected: selected,
                          ),
                        ),
                      ),
                      if (index == lastIndex) after,
                    ],
                  );
                },
                itemCount: reel.frames.length,
                controller: controller,
              );
            }),
          ),
          if (_pinned)
            GestureDetector(
              onVerticalDragUpdate: (details) {
                _draggedInDurationMode += details.primaryDelta;

                if (_draggedInDurationMode >= durationModeScrollUnit) {
                  _draggedInDurationMode -= durationModeScrollUnit;
                  // TODO: increment duration
                  // reel.addFrameSlot();
                } else if (_draggedInDurationMode <= -durationModeScrollUnit) {
                  _draggedInDurationMode += durationModeScrollUnit;
                  // TODO: decrement duration
                  // reel.removeFrameSlot();
                }
              },
            ),
        ],
      ),
    );
  }
}
