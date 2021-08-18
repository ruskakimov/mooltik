import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';
import 'package:provider/provider.dart';

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    Key? key,
    required this.layerIndex,
    required this.offset,
  }) : super(key: key);

  final int layerIndex;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final visible = timelineView.sceneLayers[layerIndex].visible;

    return TimelinePositioned(
      timestamp: timelineView.sceneStart,
      y: timelineView.rowMiddle(layerIndex),
      width: 48,
      height: 48,
      offset: offset,
      child: IconButton(
        icon: Icon(
          visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Theme.of(context).colorScheme.onBackground,
          size: 20,
        ),
        onPressed: () => timelineView.toggleLayerVisibility(layerIndex),
      ),
    );
  }
}
