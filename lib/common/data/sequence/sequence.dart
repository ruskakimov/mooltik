import 'package:mooltik/common/data/sequence/time_span.dart';

/// Manages a sequence of `TimeSpan` and offers fast derived data.
class Sequence<T extends TimeSpan> {
  Sequence(List<T> spans)
      : _spans = spans.sublist(0),
        _totalDuration = spans.fold(
          Duration.zero,
          (duration, span) => duration + span.duration,
        );

  List<T> _spans;

  T operator [](int index) => _spans[index];

  int get length => _spans.length;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;
}
