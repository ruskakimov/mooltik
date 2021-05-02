import 'dart:ui';

/// Stack of images of the same size.
class CompositeImage {
  CompositeImage(this.layers)
      : assert(layers != null),
        assert(layers.isNotEmpty),
        assert(layers.every((image) =>
            image.height == layers.first.height &&
            image.width == layers.first.width));

  /// Image layers from top to bottom.
  final List<Image> layers;

  int get width => layers.first.width;

  int get height => layers.first.height;
}

extension CompositeImageDrawing on Canvas {
  void drawCompositeImage(CompositeImage image, Offset offset, Paint paint) {
    for (final layer in image.layers.reversed) {
      drawImage(layer, offset, paint);
    }
  }
}
