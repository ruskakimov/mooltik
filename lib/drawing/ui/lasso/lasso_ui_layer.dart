import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso_model.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';
import 'package:mooltik/drawing/ui/lasso/transform_box.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/drawing/data/easel_model.dart';

class LassoUiLayer extends StatelessWidget {
  const LassoUiLayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final easel = context.watch<EaselModel>();
    final lassoModel = context.watch<LassoModel>();

    if (lassoModel.isTransformMode) {
      return Transform.translate(
        offset: lassoModel.transformBoxCenterOffset,
        child: TransformBox(size: lassoModel.transformBoxSize),
      );
    }

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
