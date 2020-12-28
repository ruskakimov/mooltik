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

class PositionedResizeHandle extends StatelessWidget {
  final double width = 24;
  final double height = 48;

  @override
  Widget build(BuildContext context) {
    final timelineView = context.watch<TimelineViewModel>();
    final timeline = context.watch<TimelineModel>();

    final frameSliverMid = timelineView.frameSliverTop +
        (timelineView.frameSliverBottom - timelineView.frameSliverTop) / 2;

    return Positioned(
      left: timelineView.xFromTime(timeline.selectedFrameEndTime) - width / 2,
      top: frameSliverMid - height / 2,
      child: ResizeHandle(
        width: width,
        height: height,
      ),
    );
  }
}

class ResizeHandle extends StatelessWidget {
  const ResizeHandle({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.primary,
      elevation: 10,
      child: SizedBox(
        width: width,
        height: height,
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
