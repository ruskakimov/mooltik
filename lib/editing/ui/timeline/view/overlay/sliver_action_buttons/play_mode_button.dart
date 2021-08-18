import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/timeline_positioned.dart';
import 'package:provider/provider.dart';

class PlayModeButton extends StatelessWidget {
  const PlayModeButton({
    Key? key,
    required this.layerIndex,
    required this.offset,
  }) : super(key: key);

  final int layerIndex;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final playMode = timelineView.sceneLayers[layerIndex].playMode;

    return TimelinePositioned(
      timestamp: timelineView.sceneStart,
      y: timelineView.rowMiddle(layerIndex),
      width: 48,
      height: 48,
      offset: offset,
      child: IconButton(
        icon: Icon(
          _getIcon(playMode),
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () => timelineView.nextScenePlayModeForLayer(layerIndex),
      ),
    );
  }

  IconData? _getIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.extendLast:
        return Icons.trending_flat_rounded;
      case PlayMode.loop:
        return Icons.autorenew_rounded;
      case PlayMode.pingPong:
        return Icons.sync_alt_rounded;
    }
  }
}
