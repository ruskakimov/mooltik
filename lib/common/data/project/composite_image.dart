import 'dart:ui' as ui;

/// Stack of images of the same size.
class CompositeImage {
  CompositeImage(this.images)
      : assert(images != null),
        assert(images.isNotEmpty),
        assert(images.every((image) =>
            image.height == images.first.height &&
            image.width == images.first.width));

  final List<ui.Image> images;

  int get width => images.first.width;

  int get height => images.first.height;
}
