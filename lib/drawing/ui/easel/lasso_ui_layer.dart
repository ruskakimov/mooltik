import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/easel_model.dart';

class LassoUiLayer extends StatelessWidget {
  const LassoUiLayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final lasso = context.watch<Lasso>();

    if (lasso.selectionStroke == null) {
      return SizedBox.shrink();
    }

    final offset = lasso.selectionStroke.boundingRect.topLeft;

    final pathTransform = Matrix4.identity()
      ..scale(easel.scale)
      ..translate(-offset.dx, -offset.dy);

    final transformedPath =
        lasso.selectionStroke.path.transform(pathTransform.storage);

    return Transform.translate(
      offset: offset * easel.scale,
      child: CustomPaint(
        size: transformedPath.getBounds().size,
        painter: SelectionPainter(selection: transformedPath),
      ),
    );
  }
}

class SelectionPainter extends CustomPainter {
  SelectionPainter({
    @required this.selection,
  });

  final Path selection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.red
      ..isAntiAlias = true
      ..strokeWidth = 1;

    canvas.drawPath(
      selection,
      paint..color = Colors.white,
    );

    canvas.drawPath(
      dashPath(
        selection,
        dashArray: CircularIntervalList<double>(<double>[
          5.0,
          6.0,
        ]),
      ),
      paint..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SelectionPainter oldDelegate) => false;
}
