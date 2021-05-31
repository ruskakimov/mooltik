import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:mooltik/drawing/data/lasso/lasso_model.dart';
import 'package:mooltik/drawing/ui/lasso/transformed_image_painter.dart';
import 'package:provider/provider.dart';

class TransformedImageLayer extends StatelessWidget {
  const TransformedImageLayer({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final lassoModel = context.watch<LassoModel>();

    if (lassoModel.transformImage == null) {
      return SizedBox.shrink();
    }

    // return CustomPaint(
    //   size: size,
    //   painter: TransformedImagePainter(
    //     transform: _getTransform(
    //       lassoModel.transformBoxDisplaySize,
    //       lassoModel.isFlippedHorizontally,
    //       lassoModel.isFlippedVertically,
    //       lassoModel.transformBoxRotation,
    //     ),
    //     transformedImage: lassoModel.transformImage,
    //   ),
    // );

    return Transform(
      transform: _getTransform(
        lassoModel.transformBoxDisplaySize,
        lassoModel.transformBoxCenterOffset,
        lassoModel.isFlippedHorizontally,
        lassoModel.isFlippedVertically,
        lassoModel.transformBoxRotation,
        lassoModel.transformBoxDisplaySize.width /
            lassoModel.transformImageOriginalSize.width,
        lassoModel.transformBoxDisplaySize.height /
            lassoModel.transformImageOriginalSize.height,
      ),
      child: CustomPaint(
        size: lassoModel.transformImageOriginalSize,
        painter: ImagePainter(lassoModel.transformImage),
      ),
    );
  }

  Matrix4 _getTransform(
    Size boxSize,
    Offset centerOffset,
    bool flipHorizontally,
    bool flipVertically,
    double angle,
    double xScale,
    double yScale,
  ) {
    var t = Matrix4Transform();
    final halfSize = boxSize.center(Offset.zero);

    t = t.translateOffset(centerOffset - halfSize);
    t = t.rotateByCenter(angle, boxSize);

    if (flipHorizontally) t = t.flipHorizontally(origin: halfSize);
    if (flipVertically) t = t.flipVertically(origin: halfSize);

    t = t.scaleBy(x: xScale, y: yScale);

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
