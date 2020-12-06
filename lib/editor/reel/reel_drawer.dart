import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/frame/frame_thumbnail.dart';
import 'package:mooltik/editor/reel/context_menu/add_in_between_button.dart';
import 'package:mooltik/editor/reel/context_menu/reel_context_menu.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/reel/reel_model.dart';

const double drawerWidth = 112.0;
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
    if (controller.hasClients && selectedId != reel.selectedFrameId) {
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
    return AnimatedLeftDrawer(
      width: drawerWidth,
      open: widget.open,
      child: PortalEntry(
        visible: _contextMenuOpen,
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
        portal: ReelContextMenu(),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    final reel = context.watch<ReelModel>();

    return LayoutBuilder(builder: (context, constraints) {
      final padding = (constraints.maxHeight - thumbnailHeight) / 2;
      final lastIndex = reel.frames.length - 1;

      return ListView.separated(
        controller: controller,
        itemCount: reel.frames.length + 1,
        separatorBuilder: (context, index) => SizedBox(height: gap),
        padding: EdgeInsets.only(
          top: padding,
          bottom: padding - thumbnailHeight,
        ),
        itemBuilder: (context, index) {
          // Add frame button.
          if (index == reel.frames.length)
            return SizedBox(
              height: thumbnailHeight,
              child: AppIconButton(
                icon: FontAwesomeIcons.plusCircle,
                onTap: reel.addFrame,
              ),
            );

          final frame = reel.frames[index];
          final selected = index == reel.selectedFrameId;

          return SizedBox(
            height: thumbnailHeight,
            child: GestureDetector(
              onTap: () {
                if (selected) {
                  setState(() => _contextMenuOpen = !_contextMenuOpen);
                }
                _scrollTo(index);
              },
              child: PortalEntry(
                visible: selected && _contextMenuOpen,
                childAnchor: Alignment(0.5, -1),
                portalAnchor: Alignment.center,
                portal: AddInBetweenButton(
                  onPressed: reel.addFrameBeforeSelected,
                ),
                child: PortalEntry(
                  visible: selected && _contextMenuOpen && index != lastIndex,
                  childAnchor: Alignment(0.5, 1),
                  portalAnchor: Alignment.center,
                  portal: AddInBetweenButton(
                    onPressed: reel.addFrameAfterSelected,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    position: DecorationPosition.foreground,
                    child: FrameThumbnail(
                      frame: frame,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
