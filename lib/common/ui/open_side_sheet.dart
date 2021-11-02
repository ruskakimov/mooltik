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
  Side side = Side.right,
}) {
  showGeneralDialog(
    barrierLabel: "Sheet Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    pageBuilder: (context, animation1, animation2) {
      final horizontalSide = side.index % 2 == 0;
      final screenEstate = horizontalSide
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height;

      var sheetExtent = min(320.0, screenEstate - 56);

      final safePadding = MediaQuery.of(context).padding;
      final safeSidePadding = [
        safePadding.left,
        safePadding.top,
        safePadding.right,
        safePadding.bottom
      ][side.index];

      sheetExtent += safeSidePadding;

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
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (context, animation1, animation2, child) {
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
