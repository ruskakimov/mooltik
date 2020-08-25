import 'package:flutter/material.dart';

class FpsStepper extends StatelessWidget {
  const FpsStepper({
    Key key,
    @required this.value,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
  }) : super(key: key);

  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => onChanged((value - 1).clamp(minValue, maxValue)),
        ),
        SizedBox(
          width: 32,
          child: Column(
            children: <Widget>[
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('fps'),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onChanged((value + 1).clamp(minValue, maxValue)),
        ),
      ],
    );
  }
}
