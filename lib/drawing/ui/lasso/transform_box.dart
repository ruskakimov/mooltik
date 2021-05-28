import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';

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

    return AnimatedSelection(
      selection: circumference,
    );
  }
}
