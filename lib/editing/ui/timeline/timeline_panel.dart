import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/data/timeline_view_model.dart';
import 'package:mooltik/editing/ui/timeline/scrollable/resize_handle.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/ui/surface.dart';
import 'package:mooltik/editing/ui/timeline/scrollable/timeline_view.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editing/ui/timeline/scrollable/playhead.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerModel>(
          create: (context) => PlayerModel(
            soundClips: context.read<Project>().soundClips,
            getNewSoundClipFile: context.read<Project>().getNewSoundClipFile,
            timeline: context.read<TimelineModel>(),
          ),
        ),
        ChangeNotifierProvider<TimelineViewModel>(
          create: (context) => TimelineViewModel(
            timeline: context.read<TimelineModel>(),
          ),
        ),
      ],
      builder: (context, child) => Surface(
        child: Column(
          children: [
            TimelineActionbar(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TimelineView(),
                  Playhead(),
                  if (context.watch<TimelineViewModel>().showFrameMenu)
                    PositionedResizeHandle(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
