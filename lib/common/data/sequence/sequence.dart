import 'package:mooltik/common/data/sequence/time_span.dart';

/// A sequence of `TimeSpan`s with a playhead.
///
/// Defines the relationship between a playhead and a list of `TimeSpan`s.
///
/// When playhead is right on the edge between two spans,
/// latest time span takes precedence.
class Sequence<T extends TimeSpan> {
  Sequence(List<T> spans)
      : _spans = spans.sublist(0),
        _playhead = Duration.zero,
        _totalDuration = spans.fold(
          Duration.zero,
          (duration, span) => duration + span.duration,
        );

  List<T> _spans;

  T operator [](int index) => _spans[index];

  int get length => _spans.length;

  Duration get playhead => _playhead;
  Duration _playhead;

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;
}
