import 'package:flutter/material.dart';
import 'package:mooltik/common/data/image_interface.dart';

const frostedGlassColor = Color(0x88A09F9F);

class PaintedGlass extends StatelessWidget {
  const PaintedGlass({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageInterface image;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: frostedGlassColor,
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: CustomPaint(
              size: image.size,
              isComplex: true,
              painter: _ImagePainter(image),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  _ImagePainter(this.image);

  final ImageInterface image;

  @override
  void paint(Canvas canvas, Size size) {
    image.draw(
      canvas,
      Offset.zero,
      Paint()
        ..isAntiAlias = true
        ..filterQuality = FilterQuality.low,
    );
  }

  @override
  bool shouldRepaint(_ImagePainter oldDelegate) => image != oldDelegate.image;

  @override
  bool shouldRebuildSemantics(_ImagePainter oldDelegate) => false;
}
