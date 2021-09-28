import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/base_image.dart';

const frostedGlassColor = Color(0x88A09F9F);

class PaintedGlass extends StatelessWidget {
  const PaintedGlass({
    Key? key,
    required this.image,
  }) : super(key: key);

  final BaseImage image;

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
            child: AnimatedBuilder(
              animation: image,
              builder: (context, child) {
                return CustomPaint(
                  size: image.size,
                  isComplex: true,
                  painter: _ImagePainter(image),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  _ImagePainter(this.image);

  final BaseImage image;

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
  bool shouldRepaint(_ImagePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_ImagePainter oldDelegate) => false;
}
