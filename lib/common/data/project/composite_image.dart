import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/image_interface.dart';
import 'package:mooltik/common/data/io/disk_image.dart';

/// Stack of images of the same size.
/// TODO: Notify listeners when any of the underlying layers update
class CompositeImage extends ChangeNotifier
    with EquatableMixin
    implements ImageInterface {
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

  Size get size => Size(width.toDouble(), height.toDouble());

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
