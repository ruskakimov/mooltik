import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';

const _knobTargetSize = 32.0;
const _rotationHandleLength = 40.0;

const _padding = EdgeInsets.only(
  top: _knobTargetSize / 2 + _rotationHandleLength,
  left: _knobTargetSize / 2,
  right: _knobTargetSize / 2,
  bottom: _knobTargetSize / 2,
);

const _knobPositions = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

class TransformBox extends StatelessWidget {
  const TransformBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    final area = Rect.fromLTWH(0, 0, size.width, size.height);
    final circumference = Path()
      ..addPolygon([
        area.topLeft,
        area.topRight,
        area.bottomRight,
        area.bottomLeft,
      ], true);

    return Transform.translate(
      // Center box around top-left corner.
      offset: Offset(
        -size.width / 2 - _padding.left,
        -size.height / 2 - _padding.top,
      ),
      child: SizedBox(
        width: size.width + _padding.horizontal,
        height: size.height + _padding.vertical,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: lassoModel.onTransformBoxPanUpdate,
              child: Padding(
                padding: _padding,
                child: AnimatedSelection(
                  selection: circumference,
                ),
              ),
            ),
            Positioned.fill(
              top: _knobTargetSize / 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: RotationHandle(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Knob(color: Color(0xFF00FF00)),
            ),
            for (var knobPosition in _knobPositions)
              Positioned.fill(
                top: _rotationHandleLength,
                child: Align(
                  alignment: knobPosition,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      lassoModel.onKnobDrag(knobPosition, details);
                    },
                    child: Knob(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RotationHandle extends StatelessWidget {
  const RotationHandle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: _rotationHandleLength,
      color: Color(0xFF00FF00),
    );
  }
}

class Knob extends StatelessWidget {
  const Knob({
    Key key,
    this.color,
  }) : super(key: key);

  final Color color;

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
            color: color ?? Theme.of(context).colorScheme.primary,
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
