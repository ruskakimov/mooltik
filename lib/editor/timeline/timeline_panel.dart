import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/player_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_scrollable.dart';
import 'package:mooltik/editor/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editor/timeline/scrollable/playhead.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerModel>(
      create: (context) => PlayerModel(
        soundClips: context.read<Project>().soundClips,
        getNewSoundClipFile: context.read<Project>().getNewSoundClipFile,
        timeline: context.read<TimelineModel>(),
      ),
      child: Surface(
        child: Column(
          children: [
            TimelineActionbar(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TimelineScrollable(),
                  Playhead(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
