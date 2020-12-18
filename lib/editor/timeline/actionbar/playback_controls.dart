import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/app_icon_button.dart';
import 'package:mooltik/editor/timeline/actionbar/step_backward_button.dart';
import 'package:mooltik/editor/timeline/actionbar/step_forward_button.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class PlaybackControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StepBackwardButton(),
        AppIconButton(
          icon: timeline.playing
              ? FontAwesomeIcons.pause
              : timeline.playheadPosition == timeline.totalDuration
                  ? FontAwesomeIcons.undoAlt
                  : FontAwesomeIcons.play,
          onTap: timeline.playing
              ? timeline.pause
              : timeline.playheadPosition == timeline.totalDuration
                  ? timeline.replay
                  : timeline.play,
        ),
        StepForwardButton(),
      ],
    );
  }
}
