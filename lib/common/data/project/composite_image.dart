import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/base_image.dart';
import 'package:mooltik/common/data/io/disk_image.dart';

/// Stack of images of the same size.
class CompositeImage extends BaseImage {
  CompositeImage(this.layers)
      : width = layers.first.width,
        height = layers.first.height,
        assert(layers.isNotEmpty &&
            layers.every((image) =>
                image.height == layers.first.height &&
                image.width == layers.first.width));

  CompositeImage.empty({
    required this.width,
    required this.height,
  }) : layers = [];

  final int width;
  final int height;

  /// Image layers from top to bottom.
  final List<DiskImage> layers;

  @override
  List<Object?> get props => [width, height, layers];

  @override
  void draw(Canvas canvas, Offset offset, Paint paint) {
    canvas.drawCompositeImage(this, offset, paint);
  }
}

extension CompositeImageDrawing on Canvas {
  void drawCompositeImage(CompositeImage image, Offset offset, Paint paint) {
    for (final layer in image.layers.reversed) {
      layer.draw(this, offset, paint);
    }
  }
}
