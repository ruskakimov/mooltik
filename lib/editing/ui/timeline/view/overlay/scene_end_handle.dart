import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';
import 'package:provider/provider.dart';

class SceneEndHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return TimelinePositioned(
      timestamp: timelineView.sceneEnd,
      y: timelineView.imageSliverMid,
      offset: const Offset(48 / 2, 0),
      width: 48,
      height: 48,
      onDragUpdate: (Duration updatedTime) =>
          timelineView.onSceneEndHandleDragUpdate(updatedTime),
      onDragEnd: (_) {
        // Keep playhead within boundaries.
        final timeline = context.read<TimelineModel>();
        timeline.jumpTo(timeline.playheadPosition);
      },
      child: RotatedBox(
        quarterTurns: 1,
        child: Icon(Icons.drag_handle_rounded),
      ),
    );
  }
}
