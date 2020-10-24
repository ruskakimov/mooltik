import 'package:flutter/material.dart';

const drawerTransitionDuration = Duration(milliseconds: 100);

enum DrawerPosition {
  left,
  right,
}

class EditorDrawer extends StatelessWidget {
  const EditorDrawer({
    Key key,
    @required this.width,
    @required this.position,
    @required this.open,
    this.child,
  }) : super(key: key);

  final double width;
  final DrawerPosition position;
  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double sideOffset = open ? 0 : -width;

    return AnimatedPositioned(
      duration: drawerTransitionDuration,
      left: position == DrawerPosition.left ? sideOffset : null,
      right: position == DrawerPosition.right ? sideOffset : null,
      top: 0,
      bottom: 0,
      width: width,
      child: ColoredBox(
        color: Colors.blueGrey[800],
        child: child,
      ),
    );
  }
}
