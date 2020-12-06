import 'package:flutter/material.dart';

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
          Text(
            durationToLabel(Duration.zero),
            style: style,
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              ' / ${durationToLabel(Duration.zero)}',
              style: style,
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
