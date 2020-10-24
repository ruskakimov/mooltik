import 'package:flutter/material.dart';

const drawerTransitionDuration = Duration(milliseconds: 150);

enum DrawerPosition {
  left,
  right,
}

abstract class AnimatedDrawer extends StatelessWidget {
  const AnimatedDrawer({
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
      curve: Curves.easeInOut,
      left: position == DrawerPosition.left ? sideOffset : null,
      right: position == DrawerPosition.right ? sideOffset : null,
      top: 0,
      bottom: 0,
      width: width,
      child: RepaintBoundary(
        child: ColoredBox(
          color: Colors.blueGrey[800],
          child: child,
        ),
      ),
    );
  }
}

class AnimatedLeftDrawer extends AnimatedDrawer {
  const AnimatedLeftDrawer({
    Key key,
    @required double width,
    @required bool open,
    Widget child,
  }) : super(
          key: key,
          width: width,
          position: DrawerPosition.left,
          open: open,
          child: child,
        );
}

class AnimatedRightDrawer extends AnimatedDrawer {
  const AnimatedRightDrawer({
    Key key,
    @required double width,
    @required bool open,
    Widget child,
  }) : super(
          key: key,
          width: width,
          position: DrawerPosition.right,
          open: open,
          child: child,
        );
}
