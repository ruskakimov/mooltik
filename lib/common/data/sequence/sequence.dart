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
        _currentIndex = 0,
        _currentSpanStart = Duration.zero,
        _totalDuration = spans.fold(
          Duration.zero,
          (duration, span) => duration + span.duration,
        );

  List<T> _spans;

  T operator [](int index) => _spans[index];

  int get length => _spans.length;

  T get current => _spans[_currentIndex];

  int get currentIndex => _currentIndex;
  int _currentIndex;

  Duration _currentSpanStart;
  Duration get _currentSpanEnd => _currentSpanStart + current.duration;

  Duration get playhead => _playhead;
  Duration _playhead;
  set playhead(Duration value) {
    if (value < Duration.zero || value > totalDuration) {
      throw Exception('Invalid playhead value.');
    }

    _playhead = value;
    _syncCurrentSpanWithPlayhead();
  }

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;

  void _syncCurrentSpanWithPlayhead() {
    while (_playhead < _currentSpanStart && _currentIndex > 0) {
      _currentIndex--;
      _currentSpanStart -= current.duration;
    }

    while (_playhead >= _currentSpanEnd && _currentIndex < _spans.length - 1) {
      _currentSpanStart = _currentSpanEnd;
      _currentIndex++;
    }
  }
}
