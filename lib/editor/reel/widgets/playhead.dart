import 'package:flutter/material.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';

class Playhead extends StatelessWidget {
  const Playhead({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Duration playheadPosition = null;
    // context.select<ReelModel, Duration>(
    //   (ReelModel reel) => reel.playheadPosition,
    // );

    return Center(
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Text(
                durationToLabel(playheadPosition),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 2,
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String durationToLabel(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String min = twoDigits(duration.inMinutes);
    String sec = twoDigits(duration.inSeconds.remainder(60));
    String secFr = twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return '$min:$sec.$secFr';
  }
}
