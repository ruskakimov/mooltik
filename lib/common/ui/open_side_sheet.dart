import 'dart:math';
import 'package:flutter/material.dart';

enum Side {
  left,
  top,
  right,
  bottom,
}

const sideAlignments = [
  Alignment.centerLeft,
  Alignment.topCenter,
  Alignment.centerRight,
  Alignment.bottomCenter,
];

const hiddenOffset = [
  Offset(-1, 0),
  Offset(0, -1),
  Offset(1, 0),
  Offset(0, 1),
];

openSideSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Side portraitSide = Side.right,
  Side landscapeSide = Side.right,
  double maxExtent = 320,
  Duration transitionDuration = const Duration(milliseconds: 250),
}) {
  showGeneralDialog(
    barrierLabel: "Sheet Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    pageBuilder: (context, animation1, animation2) {
      final side = MediaQuery.of(context).orientation == Orientation.portrait
          ? portraitSide
          : landscapeSide;

      final horizontalSide = side.index % 2 == 0;
      final screenEstate = horizontalSide
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height;

      final safePadding = MediaQuery.of(context).padding;
      final sideSafePadding = [
        safePadding.left,
        safePadding.top,
        safePadding.right,
        safePadding.bottom
      ][side.index];

      final contentEstate = horizontalSide
          ? screenEstate - safePadding.horizontal
          : screenEstate - safePadding.vertical;

      final sheetExtent = min(maxExtent, contentEstate - 56) + sideSafePadding;

      return Align(
        alignment: sideAlignments[side.index],
        child: SizedBox(
          height: horizontalSide ? double.infinity : sheetExtent,
          width: !horizontalSide ? double.infinity : sheetExtent,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              left: side == Side.left,
              top: side == Side.top,
              right: side == Side.right,
              bottom: side == Side.bottom,
              child: builder(context),
            ),
          ),
        ),
      );
    },
    transitionDuration: transitionDuration,
    transitionBuilder: (context, animation1, animation2, child) {
      final side = MediaQuery.of(context).orientation == Orientation.portrait
          ? portraitSide
          : landscapeSide;

      return SlideTransition(
        position: Tween(
          begin: hiddenOffset[side.index],
          end: Offset(0, 0),
        ).chain(CurveTween(curve: Curves.ease)).animate(animation1),
        child: child,
      );
    },
  );
}
