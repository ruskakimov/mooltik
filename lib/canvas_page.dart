import 'package:flutter/material.dart';

import 'painter.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Painter(),
    );
  }
}
