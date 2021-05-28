import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';

const _knobTargetSize = 32.0;

class TransformBox extends StatelessWidget {
  const TransformBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    final circumference = Path()
      ..addPolygon([
        area.topLeft,
        area.topRight,
        area.bottomRight,
        area.bottomLeft,
      ], true);

    return Transform.translate(
      offset: const Offset(-_knobTargetSize, -_knobTargetSize),
      child: SizedBox(
        width: size.width + _knobTargetSize,
        height: size.height + _knobTargetSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(_knobTargetSize / 2),
              child: AnimatedSelection(
                selection: circumference,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Knob(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Knob(),
            ),
          ],
        ),
      ),
    );
  }
}

class Knob extends StatelessWidget {
  const Knob({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _knobTargetSize,
      height: _knobTargetSize,
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
