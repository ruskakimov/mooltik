import 'package:flutter/material.dart';

class TimeLabel extends StatelessWidget {
  const TimeLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        durationToLabel(Duration.zero),
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
