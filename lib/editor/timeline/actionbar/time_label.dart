import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:provider/provider.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          _PlayheadTimeLabel(style: style),
          _TotalTimeLabel(style: style),
        ],
      ),
    );
  }
}

class _PlayheadTimeLabel extends StatelessWidget {
  const _PlayheadTimeLabel({
    Key key,
    @required this.style,
  }) : super(key: key);

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      durationToLabel(context.select<TimelineModel, Duration>(
        (timeline) => timeline.playheadPosition,
      )),
      style: style,
    );
  }
}

class _TotalTimeLabel extends StatelessWidget {
  const _TotalTimeLabel({
    Key key,
    @required this.style,
  }) : super(key: key);

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final totalLabel = durationToLabel(context.select<TimelineModel, Duration>(
      (timeline) => timeline.totalDuration,
    ));

    return Opacity(
      opacity: 0.5,
      child: Text(
        ' / $totalLabel',
        style: style,
      ),
    );
  }
}

String durationToLabel(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String min = twoDigits(duration.inMinutes);
  String sec = twoDigits(duration.inSeconds.remainder(60));
  String secFr = twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
  return '$min:$sec.$secFr';
}
