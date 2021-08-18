import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';

const _width = 48.0;

class SliverActionButton extends StatelessWidget {
  const SliverActionButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.rowIndex,
    required this.colIndex,
  }) : super(key: key);

  final IconData? iconData;
  final VoidCallback onPressed;

  final int rowIndex;
  final int colIndex;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return TimelinePositioned(
      timestamp: timelineView.sceneStart,
      y: timelineView.rowMiddle(rowIndex),
      width: _width,
      height: _width,
      offset: Offset(-32.0 - _width * colIndex, 0),
      child: IconButton(
        icon: Icon(
          iconData,
          color: Theme.of(context).colorScheme.onBackground,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
