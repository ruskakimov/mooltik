import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:mooltik/editing/data/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();

    // Pause
    if (timeline.isPlaying)
      return AppIconButton(
        icon: FontAwesomeIcons.pause,
        onTap: () {
          timeline.pause();
        },
      );

    // Play
    return AppIconButton(
      icon: FontAwesomeIcons.play,
      onTap: () async {
        if (timeline.playheadPosition == timeline.playheadEndBound) {
          timeline.jumpTo(timeline.playheadStartBound);
        }
        await context.read<PlayerModel>().prepare();
        timeline.play();
      },
    );
  }
}
