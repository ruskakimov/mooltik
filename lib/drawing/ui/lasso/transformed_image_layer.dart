import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
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
          lassoModel.transformBoxRotation,
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
    double angle,
  ) {
    var t = Matrix4Transform();
    final halfSize = boxSize.center(Offset.zero);

    t = t.translateOffset(-halfSize);
    t = t.rotateByCenter(angle, boxSize);

    if (flipHorizontally) t = t.flipHorizontally(origin: halfSize);
    if (flipVertically) t = t.flipVertically(origin: halfSize);

    return t.matrix4;
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
