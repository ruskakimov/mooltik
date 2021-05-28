import 'package:flutter/material.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/easel_model.dart';

class LassoUiLayer extends StatelessWidget {
  const LassoUiLayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();

    if (easel.selectionStroke == null) {
      return SizedBox.shrink();
    }

    final offset = easel.selectionStroke.boundingRect.topLeft;

    final pathTransform = Matrix4.identity()
      ..scale(easel.scale)
      ..translate(-offset.dx, -offset.dy);

    final transformedPath =
        easel.selectionStroke.path.transform(pathTransform.storage);

    return Transform.translate(
      offset: offset * easel.scale,
      child: AnimatedSelection(selection: transformedPath),
    );
  }
}
