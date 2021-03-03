import 'package:flutter/material.dart';

class PickerOptionButton extends StatelessWidget {
  const PickerOptionButton({
    Key key,
    this.innerCircleWidth = maxInnerCircleWidth,
    this.innerCircleColor = Colors.white,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  static const double circleSize = 44;

  static const double minInnerCircleWidth = 4;
  static const double maxInnerCircleWidth = 34;

  final double innerCircleWidth;
  final Color innerCircleColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: circleSize / 2,
      onTap: onTap,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          border: selected
              ? Border.all(
                  color: Colors.white,
                  width: 3,
                )
              : null,
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: innerCircleWidth,
            decoration: BoxDecoration(
              color: innerCircleColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
