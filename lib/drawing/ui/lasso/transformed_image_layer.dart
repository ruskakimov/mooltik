import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/ui/lasso/transformed_image_painter.dart';
import 'package:provider/provider.dart';

class TransformedImageLayer extends StatelessWidget {
  const TransformedImageLayer({
    Key key,
    @required this.frameSize,
  }) : super(key: key);

  final Size frameSize;

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    if (lassoModel.transformImage == null) {
      return SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.fill,
      child: CustomPaint(
        size: frameSize,
        painter: TransformedImagePainter(
          transform: lassoModel.imageTransform,
          transformedImage: lassoModel.transformImage,
        ),
      ),
    );
  }
}
