import 'package:flutter/material.dart';
import 'package:mooltik/editor/sound_clip.dart';
import 'package:mooltik/editor/timeline/player_model.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_painter.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';
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
