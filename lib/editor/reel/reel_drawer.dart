import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/reel/timeline.dart';
import 'package:mooltik/editor/reel/widgets/playhead.dart';
import 'package:mooltik/editor/reel/widgets/reel_context_menu.dart';
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
  bool _contextMenuOpen = false;

  ReelModel get reel => context.read<ReelModel>();

  void toggleMenu() {
    setState(() => _contextMenuOpen = !_contextMenuOpen);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomDrawer(
      height: 120,
      open: widget.open,
      child: PortalEntry(
        visible: _contextMenuOpen,
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
        portal: ReelContextMenu(),
        child: Stack(
          children: [
            Timeline(),
            Playhead(),
          ],
        ),
      ),
    );
  }
}
