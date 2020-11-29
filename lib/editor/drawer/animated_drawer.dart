import 'package:flutter/material.dart';
import 'package:mooltik/common/surface.dart';

const drawerTransitionDuration = Duration(milliseconds: 150);

enum DrawerPosition {
  left,
  right,
}

abstract class AnimatedSideDrawer extends StatelessWidget {
  const AnimatedSideDrawer({
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
        child: Surface(
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AnimatedLeftDrawer extends AnimatedSideDrawer {
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

class AnimatedRightDrawer extends AnimatedSideDrawer {
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

class AnimatedBottomDrawer extends StatelessWidget {
  const AnimatedBottomDrawer({
    Key key,
    @required this.height,
    @required this.open,
    this.child,
  }) : super(key: key);

  final double height;
  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double bottomOffset = open ? 0 : -height;

    return AnimatedPositioned(
      duration: drawerTransitionDuration,
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: bottomOffset,
      height: height,
      child: RepaintBoundary(
        child: Surface(
          child: child,
        ),
      ),
    );
  }
}
