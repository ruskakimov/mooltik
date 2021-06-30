import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';

/// Composite image with duration.
class CompositeFrame extends TimeSpan with EquatableMixin {
  CompositeFrame(this.compositeImage, Duration duration) : super(duration);

  final CompositeImage compositeImage;

  int get width => compositeImage.width;

  int get height => compositeImage.height;

  @override
  TimeSpan copyWith({Duration? duration}) => CompositeFrame(
        this.compositeImage,
        duration ?? this.duration,
      );

  Future<ui.Image> toImage() => generateImage(
        CompositeImagePainter(compositeImage),
        width,
        height,
      );

  @override
  List<Object?> get props => [width, height, compositeImage, duration];
}
