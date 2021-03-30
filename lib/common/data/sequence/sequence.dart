import 'package:mooltik/common/data/sequence/time_span.dart';

/// Manages a sequence of `TimeSpan` and offers fast derived data.
class Sequence<T extends TimeSpan> {
  Sequence(List<T> spans)
      : _spans = spans,
        _totalDuration = spans.fold(
          Duration.zero,
          (duration, span) => duration + span.duration,
        );

  // TODO: Override [] operator.
  List<T> get spans => _spans;
  List<T> _spans;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;
}
