import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

/// Composite image with duration.
class CompositeFrame extends TimeSpan
    with EquatableMixin
    implements FrameInterface {
  CompositeFrame(this.image, Duration duration) : super(duration);

  final CompositeImage image;

  int get width => image.width;

  int get height => image.height;

  @override
  TimeSpan copyWith({Duration? duration}) => CompositeFrame(
        this.image,
        duration ?? this.duration,
      );

  Future<ui.Image> toImage() => generateImage(
        CompositeImagePainter(image),
        width,
        height,
      );

  @override
  List<Object?> get props => [width, height, image, duration];
}
