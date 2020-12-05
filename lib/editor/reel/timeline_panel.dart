import 'package:flutter/material.dart';
import 'package:mooltik/common/surface.dart';
import 'package:mooltik/editor/reel/timeline.dart';
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
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Timeline(),
                // Playhead(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
