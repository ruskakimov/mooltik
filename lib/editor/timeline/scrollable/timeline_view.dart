import 'package:flutter/material.dart';
import 'package:mooltik/editor/sound_clip.dart';
import 'package:mooltik/editor/timeline/player_model.dart';
import 'package:mooltik/editor/timeline/scrollable/convert.dart';
import 'package:mooltik/editor/timeline/scrollable/timeline_painter.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key key}) : super(key: key);

  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  double msPerPx = 10;
  double _prevMsPerPx = 10;
  double _scaleOffset;
  Offset _prevFocalPoint;

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    final timelineWidth = durationToPx(timeline.totalDuration, msPerPx);

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _prevMsPerPx = msPerPx;
        _prevFocalPoint = details.localFocalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _scaleOffset ??= 1 - details.scale;
        setState(() {
          msPerPx = _prevMsPerPx / (details.scale + _scaleOffset);
        });

        final diff = (details.localFocalPoint - _prevFocalPoint);
        timeline.scrub(-diff.dx / timelineWidth);
        _prevFocalPoint = details.localFocalPoint;
      },
      onScaleEnd: (ScaleEndDetails details) {
        _scaleOffset = null;
      },
      onTapUp: (TapUpDetails details) {
        print(details.localPosition);
        // details.localPosition.dy < frameSliverTop
        // details.localPosition.dy > frameSliverBottom
        // iterate visibleFrameSlivers
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black.withOpacity(0.2),
          child: CustomPaint(
            painter: TimelinePainter(
              frames: timeline.frames,
              selectedFrameIndex: timeline.selectedFrameIndex,
              selectedFrameStartTime: timeline.selectedFrameStartTime,
              msPerPx: msPerPx,
              playheadPosition: timeline.playheadPosition,
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
