import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sound_clip.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/scrollable/timeline_painter.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();

    return GestureDetector(
      onScaleStart: timelineView.onScaleStart,
      onScaleUpdate: timelineView.onScaleUpdate,
      onScaleEnd: timelineView.onScaleEnd,
      onTapUp: timelineView.onTapUp,
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.2),
          child: CustomPaint(
            painter: TimelinePainter(
              timelineView: timelineView,
              soundBite: context.select<PlayerModel, SoundClip>(
                (PlayerModel player) => player.soundClips.isNotEmpty
                    ? player.soundClips.first
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
