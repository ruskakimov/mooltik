import 'package:flutter/material.dart';

class ResizeHandle extends StatelessWidget {
  const ResizeHandle({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.primary,
      elevation: 10,
      child: SizedBox(
        width: width,
        height: height,
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.drag_handle_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
