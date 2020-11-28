import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/reel/playhead.dart';
import 'package:mooltik/editor/reel/reel_context_menu.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/reel/reel_model.dart';

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

  double msPerPx = 10;
  double _prevMsPerPx = 10;
  double _scaleOffset;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(initialScrollOffset: 0)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    reel.playheadPosition = pxToDuration(controller.offset);
  }

  Duration pxToDuration(double offset) =>
      Duration(milliseconds: (offset * msPerPx).floor());

  double durationToPx(Duration duration) => duration.inMilliseconds / msPerPx;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (controller.hasClients &&
    //     selectedId != reel.selectedFrameId &&
    //     !reel.playing) {
    //   controller.removeListener(_onScroll);
    //   _scrollTo(reel.selectedFrameId);
    //   controller.addListener(_onScroll);
    // }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() => _contextMenuOpen = !_contextMenuOpen);
  }

  @override
  Widget build(BuildContext context) {
    // Update when selected frame is painted on.
    context.watch<FrameModel>();

    return AnimatedBottomDrawer(
      height: 160,
      open: widget.open,
      child: PortalEntry(
        visible: _contextMenuOpen,
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
        portal: ReelContextMenu(),
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            _prevMsPerPx = msPerPx;
            controller.removeListener(_onScroll);
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            _scaleOffset ??= 1 - details.scale;
            setState(() {
              msPerPx = _prevMsPerPx / (details.scale + _scaleOffset);
              controller.jumpTo(durationToPx(reel.playheadPosition));
            });
          },
          onScaleEnd: (ScaleEndDetails details) {
            _scaleOffset = null;
            controller.addListener(_onScroll);
          },
          child: Stack(
            children: [
              _buildList(),
              Playhead(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final reel = context.watch<ReelModel>();

    return LayoutBuilder(builder: (context, constraints) {
      final padding = constraints.maxHeight / 2;

      return ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: controller,
        itemCount: reel.frames.length,
        padding: EdgeInsets.only(
          top: padding,
          bottom: padding,
        ),
        itemBuilder: (context, index) {
          final frame = reel.frames[index];
          final selected = index == reel.selectedFrameId;

          return Container(
            height: durationToPx(frame.duration),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 0.5,
              ),
            ),
          );
        },
      );
    });
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
