import 'package:flutter/material.dart';

class PickerOptionButton extends StatelessWidget {
  const PickerOptionButton({
    Key key,
    this.size = 44,
    this.innerCircleWidth = maxInnerCircleWidth,
    this.innerCircleColor = Colors.white,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  static const double minInnerCircleWidth = 4;
  static const double maxInnerCircleWidth = 34;

  final double size;
  final double innerCircleWidth;
  final Color innerCircleColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: size / 2,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
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
