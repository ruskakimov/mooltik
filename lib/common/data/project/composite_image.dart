import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/io/disk_image.dart';

/// Stack of images of the same size.
class CompositeImage with EquatableMixin {
  CompositeImage({
    required this.width,
    required this.height,
    required this.layers,
  }) : assert(layers
            .every((image) => image.height == height && image.width == width));

  final int width;
  final int height;

  /// Image layers from top to bottom.
  final List<DiskImage> layers;

  Size get size => Size(width.toDouble(), height.toDouble());

  @override
  List<Object?> get props => [width, height, layers];

  factory CompositeImage.fromJson(Map<String, dynamic> json) => CompositeImage(
        width: json[_widthKey],
        height: json[_heightKey],
        layers: (json[_layersKey] as List)
            .map((json) => DiskImage.fromJson(json))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        _widthKey: width,
        _heightKey: height,
        _layersKey: layers.map((layer) => layer.toJson()).toList(),
      };

  static const String _widthKey = 'width';
  static const String _heightKey = 'height';
  static const String _layersKey = 'layers';
}

extension CompositeImageDrawing on Canvas {
  void drawCompositeImage(CompositeImage image, Offset offset, Paint paint) {
    for (final layer in image.layers.reversed) {
      drawImage(layer.snapshot!, offset, paint);
    }
  }
}
