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

    return Positioned(
      top: lassoModel.transformBoxCenterOffset.dy,
      left: lassoModel.transformBoxCenterOffset.dx,
      width: lassoModel.transformBoxDisplaySize.width,
      height: lassoModel.transformBoxDisplaySize.height,
      child: Transform(
        transform: _getTransform(
          lassoModel.transformBoxDisplaySize,
          lassoModel.isFlippedHorizontally,
          lassoModel.isFlippedVertically,
        ),
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

  Matrix4 _getTransform(
    Size boxSize,
    bool flipHorizontally,
    bool flipVertically,
  ) {
    final transform = Matrix4.identity();

    if (flipHorizontally) transform.rotateY(math.pi);
    if (flipVertically) transform.rotateX(math.pi);

    final centeringOffset = -boxSize.center(Offset.zero);
    transform.translate(centeringOffset.dx, centeringOffset.dy);

    return transform;
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
