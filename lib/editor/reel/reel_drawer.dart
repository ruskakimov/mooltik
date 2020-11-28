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

import 'reel_row.dart';

const double drawerWidth = 160.0;
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
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
        portal: ReelContextMenu(),
        child: Stack(
          children: [
            _buildList(),
            Playhead(),
          ],
        ),
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
                childAnchor: Alignment.topCenter,
                portalAnchor: Alignment.center,
                portal: AddInBetweenButton(
                  onPressed: reel.addFrameBeforeSelected,
                ),
                child: PortalEntry(
                  visible: selected && _contextMenuOpen && index != lastIndex,
                  childAnchor: Alignment.bottomCenter,
                  portalAnchor: Alignment.center,
                  portal: AddInBetweenButton(
                    onPressed: reel.addFrameAfterSelected,
                  ),
                  child: ReelRow(
                    frame: frame,
                    selected: selected,
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

class Playhead extends StatelessWidget {
  const Playhead({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 2,
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Container(
            height: 1.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class AddInBetweenButton extends StatelessWidget {
  const AddInBetweenButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      elevation: 5,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        FontAwesomeIcons.plus,
        size: 13,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      onPressed: onPressed,
    );
  }
}
