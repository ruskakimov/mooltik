import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

/// Composite image with duration.
class CompositeFrame extends TimeSpan {
  CompositeFrame(this.compositeImage, Duration duration) : super(duration);

  final CompositeImage compositeImage;

  int get width => compositeImage.width;

  int get height => compositeImage.height;

  @override
  TimeSpan copyWith({Duration duration}) => CompositeFrame(
        this.compositeImage,
        duration ?? this.duration,
      );
}
