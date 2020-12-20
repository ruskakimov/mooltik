import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/timeline/actionbar/step_backward_button.dart';
import 'package:mooltik/editor/timeline/actionbar/step_forward_button.dart';
import 'package:mooltik/editor/timeline/player_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class PlaybackControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StepBackwardButton(),
        _buildMiddleButton(context),
        StepForwardButton(),
      ],
    );
  }

  Widget _buildMiddleButton(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    final player = context.watch<PlayerModel>();

    // Pause
    if (timeline.isPlaying)
      return AppIconButton(
        icon: FontAwesomeIcons.pause,
        onTap: () {
          timeline.pause();
        },
      );

    // Replay
    if (timeline.playheadPosition == timeline.totalDuration)
      return AppIconButton(
        icon: FontAwesomeIcons.undoAlt,
        onTap: () async {
          await player.primePlayer();
          timeline.replay();
        },
      );

    // Play
    return AppIconButton(
      icon: FontAwesomeIcons.play,
      onTap: () async {
        await player.primePlayer();
        timeline.play();
      },
    );
  }
}
