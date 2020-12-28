import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/player_model.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view_model.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/home/project.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_view.dart';
import 'package:mooltik/editor/timeline/actionbar/timeline_actionbar.dart';
import 'package:mooltik/editor/timeline/scrollable/playhead.dart';

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
      child: Surface(
        child: Column(
          children: [
            TimelineActionbar(),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  TimelineView(),
                  Playhead(),
                  Positioned(
                    top: 15,
                    left: 457,
                    child: const ResizeHandle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResizeHandle extends StatelessWidget {
  const ResizeHandle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.primary,
      elevation: 10,
      child: SizedBox(
        height: 48,
        width: 24,
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.drag_handle_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
