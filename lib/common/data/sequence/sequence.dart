import 'package:mooltik/common/data/sequence/time_span.dart';

/// Manages a sequence of `TimeSpan` and offers fast derived data.
class Sequence<T extends TimeSpan> {
  Sequence(this.spans)
      : _totalDuration = spans.fold(
          Duration.zero,
          (duration, span) => duration + span.duration,
        );

  final List<T> spans;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;
}
