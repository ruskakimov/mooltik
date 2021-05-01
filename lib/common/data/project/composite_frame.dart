import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

/// Composite image with duration.
class CompositeFrame extends TimeSpan {
  CompositeFrame(this.compositeImage, Duration duration) : super(duration);

  final CompositeImage compositeImage;

  @override
  TimeSpan copyWith({Duration duration}) => CompositeFrame(
        this.compositeImage,
        duration ?? this.duration,
      );
}
