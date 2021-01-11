import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/toolbox/toolbox_model.dart';

class SizePicker extends StatelessWidget {
  const SizePicker({
    Key key,
    this.pickerRadius = 60,
    this.smallestInnerCircleRadius = 5,
    this.dragSensitivity = 0.4,
  }) : super(key: key);

  final double pickerRadius;
  final double smallestInnerCircleRadius;
  final double dragSensitivity;

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        final toolWidthRange = toolbox.selectedTool.maxStrokeWidth -
            toolbox.selectedTool.minStrokeWidth;
        final innerCircleRadiusRange = pickerRadius - smallestInnerCircleRadius;

        final strokeWidthDelta = -details.delta.dy /
            innerCircleRadiusRange *
            toolWidthRange *
            dragSensitivity;

        toolbox.changeToolStrokeWidth(
            toolbox.selectedToolStrokeWidth + strokeWidthDelta);
      },
      child: _Circle(
        radius: pickerRadius,
        color: Color(0xC4C4C4).withOpacity(0.5),
        child: Center(
          child: _Circle(
            radius: _calcInnerCircleRadius(
              toolbox.selectedToolStrokeWidth,
              toolbox.selectedTool.minStrokeWidth,
              toolbox.selectedTool.maxStrokeWidth,
            ),
            color: Colors.black,
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }

  double _calcInnerCircleRadius(
    double value,
    double minValue,
    double maxValue,
  ) {
    final fraction = (value - minValue) / (maxValue - minValue);
    return smallestInnerCircleRadius +
        (pickerRadius - smallestInnerCircleRadius) * fraction;
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    Key key,
    @required this.radius,
    @required this.color,
    this.border,
    this.child,
  }) : super(key: key);

  final double radius;
  final Color color;
  final BoxBorder border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border,
      ),
      child: child,
    );
  }
}
