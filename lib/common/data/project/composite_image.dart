import 'dart:ui';

/// Stack of images of the same size.
class CompositeImage {
  CompositeImage({
    required this.width,
    required this.height,
    required this.layers,
  }) : assert(layers
            .every((image) => image.height == height && image.width == width));

  final int width;
  final int height;

  /// Image layers from top to bottom.
  final List<Image> layers;

  Size get size => Size(width.toDouble(), height.toDouble());
}

extension CompositeImageDrawing on Canvas {
  void drawCompositeImage(CompositeImage image, Offset offset, Paint paint) {
    for (final layer in image.layers.reversed) {
      drawImage(layer, offset, paint);
    }
  }
}
