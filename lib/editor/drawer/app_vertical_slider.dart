import 'package:flutter/material.dart';

class AppVerticalSlider extends StatelessWidget {
  const AppVerticalSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final double value;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              '${value.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: value,
              min: 1.0,
              max: 100.0,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
