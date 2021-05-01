import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';
import 'package:provider/provider.dart';

class PlayModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return TimelinePositioned(
      timestamp: timelineView.sceneStart,
      y: timelineView.imageSliverMid,
      width: 48,
      height: 48,
      offset: Offset(-32, 0),
      child: IconButton(
        icon: Icon(_getIcon(context)),
        onPressed: timelineView.nextScenePlayMode,
      ),
    );
  }

  IconData _getIcon(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    switch (timeline.currentScene.layer.playMode) {
      case PlayMode.extendLast:
        return Icons.trending_flat_rounded;
      case PlayMode.loop:
        return Icons.autorenew_rounded;
      case PlayMode.pingPong:
        return Icons.sync_alt_rounded;
    }
    return null;
  }
}
