import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:provider/provider.dart';

class TransformedImageLayer extends StatelessWidget {
  const TransformedImageLayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    if (lassoModel.transformImage == null) {
      return SizedBox.shrink();
    }

    final centeringOffset =
        -lassoModel.transformBoxDisplaySize.center(Offset.zero);
    final transform = Matrix4.identity();

    if (lassoModel.isFlippedHorizontally) {
      transform.rotateY(math.pi);
    }

    if (lassoModel.isFlippedVertically) {
      transform.rotateX(math.pi);
    }

    transform.translate(centeringOffset.dx, centeringOffset.dy);

    return Positioned(
      top: lassoModel.transformBoxCenterOffset.dy,
      left: lassoModel.transformBoxCenterOffset.dx,
      width: lassoModel.transformBoxDisplaySize.width,
      height: lassoModel.transformBoxDisplaySize.height,
      child: Transform(
        transform: transform,
        child: FittedBox(
          fit: BoxFit.fill,
          child: CustomPaint(
            size: lassoModel.transformImageOriginalSize,
            painter: ImagePainter(lassoModel.transformImage),
          ),
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  ImagePainter(this.image);

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ImagePainter oldDelegate) => false;
}
