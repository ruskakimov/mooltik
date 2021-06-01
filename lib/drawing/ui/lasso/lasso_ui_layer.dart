import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/ui/easel/animated_selection.dart';
import 'package:mooltik/drawing/ui/lasso/transform_box.dart';
import 'package:provider/provider.dart';

class LassoUiLayer extends StatelessWidget {
  const LassoUiLayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    if (lassoModel.isTransformMode) {
      return Transform.translate(
        offset: lassoModel.transformBoxCenterOffset,
        child: TransformBox(size: lassoModel.transformBoxDisplaySize),
      );
    }

    if (lassoModel.selectionStroke == null) {
      return SizedBox.shrink();
    }

    return Transform.translate(
      offset: lassoModel.selectionOffset,
      child: AnimatedSelection(selection: lassoModel.selectionPath),
    );
  }
}
