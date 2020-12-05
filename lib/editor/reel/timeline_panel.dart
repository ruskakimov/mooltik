import 'package:flutter/material.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/reel/timeline.dart';
import 'package:mooltik/editor/reel/timeline_actionbar.dart';
import 'package:mooltik/editor/reel/widgets/playhead.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Column(
        children: [
          TimelineActionbar(),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Timeline(),
                Playhead(),
              ],
            ),
          ),
        ],
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
