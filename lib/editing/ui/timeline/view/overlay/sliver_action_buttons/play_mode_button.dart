import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/view/overlay/sliver_action_buttons/sliver_action_button.dart';
import 'package:provider/provider.dart';

class PlayModeButton extends StatelessWidget {
  const PlayModeButton({
    Key? key,
    required this.rowIndex,
    required this.colIndex,
  }) : super(key: key);

  final int rowIndex;
  final int colIndex;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final playMode = timelineView.layerPlayMode(rowIndex);

    return SliverActionButton(
      iconData: _getIcon(playMode),
      onPressed: () => timelineView.nextScenePlayModeForLayer(rowIndex),
      rowIndex: rowIndex,
      colIndex: colIndex,
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
