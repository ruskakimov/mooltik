import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/reel_context_menu.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/reel/reel_model.dart';

import 'frame_thumbnail.dart';

const double drawerWidth = 140.0;
const double thumbnailHeight = 64.0;
const double gap = 1.0;

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
  bool _contextMenuOpen = false;

  ReelModel get reel => context.read<ReelModel>();

  int get selectedId => (controller.offset / (thumbnailHeight + gap)).round();

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: reel.selectedFrameId * thumbnailHeight,
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
      index * (thumbnailHeight + gap),
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

    return AnimatedLeftDrawer(
      width: drawerWidth,
      open: widget.open,
      child: PortalEntry(
        visible: _contextMenuOpen,
        portal: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _contextMenuOpen = false;
            });
          },
        ),
        child: PortalEntry(
          visible: _contextMenuOpen,
          portalAnchor: Alignment.centerLeft,
          childAnchor: Alignment.centerRight,
          portal: ReelContextMenu(),
          child: _buildList(),
        ),
      ),
    );
  }

  Widget _buildList() {
    final reel = context.watch<ReelModel>();

    return LayoutBuilder(builder: (context, constraints) {
      final padding = (constraints.maxHeight - thumbnailHeight) / 2;
      final lastIndex = reel.frames.length - 1;

      final before = SizedBox(height: padding);
      final after = SizedBox(
        height: padding,
        child: Column(
          children: [
            SizedBox(
              height: thumbnailHeight,
              child: AppIconButton(
                icon: FontAwesomeIcons.plusCircle,
                onTap: reel.addFrame,
              ),
            ),
          ],
        ),
      );

      return ListView.separated(
        controller: controller,
        itemCount: reel.frames.length,
        separatorBuilder: (context, index) => SizedBox(height: gap),
        itemBuilder: (context, index) {
          final frame = reel.frames[index];
          final selected = index == reel.selectedFrameId;
          return Column(
            children: [
              if (index == 0) before,
              SizedBox(
                height: thumbnailHeight,
                child: GestureDetector(
                  onTap: () {
                    if (selected) {
                      setState(() => _contextMenuOpen = true);
                    }
                    _scrollTo(index);
                  },
                  child: PortalEntry(
                    visible: selected && _contextMenuOpen,
                    childAnchor: Alignment.topCenter,
                    portalAnchor: Alignment.center,
                    portal: FloatingActionButton(
                      mini: true,
                      elevation: 5,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: () {},
                    ),
                    child: PortalEntry(
                      visible:
                          selected && _contextMenuOpen && index != lastIndex,
                      childAnchor: Alignment.bottomCenter,
                      portalAnchor: Alignment.center,
                      portal: FloatingActionButton(
                        mini: true,
                        elevation: 5,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        onPressed: () {},
                      ),
                      child: FrameThumbnail(
                        frame: frame,
                        selected: selected,
                      ),
                    ),
                  ),
                ),
              ),
              if (index == lastIndex) after,
            ],
          );
        },
      );
    });
  }
}
