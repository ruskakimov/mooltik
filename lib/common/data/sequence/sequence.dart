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
  set currentIndex(int index) {
    _validateIndex(index);
    while (_currentIndex > index && stepBackwardAvailable) {
      stepBackward();
    }
    while (_currentIndex < index && stepForwardAvailable) {
      stepForward();
    }
  }

  void _validateIndex(int index) {
    if (index < 0 || index >= _spans.length) {
      throw Exception(
        'Index value $index is outside of 0-${_spans.length - 1} range.',
      );
    }
  }

  Duration _currentSpanStart;
  Duration get _currentSpanEnd => _currentSpanStart + current.duration;

  Duration get playhead => _playhead;
  Duration _playhead;
  set playhead(Duration value) {
    if (value < Duration.zero || value > totalDuration) {
      throw Exception('Invalid playhead value.');
    }
    _playhead = value;
    _syncIndexWithPlayhead();
  }

  void _syncIndexWithPlayhead() {
    while (_playhead < _currentSpanStart && stepBackwardAvailable) {
      _currentIndex--;
      _currentSpanStart -= current.duration;
    }

    while (_playhead >= _currentSpanEnd && stepForwardAvailable) {
      _currentSpanStart = _currentSpanEnd;
      _currentIndex++;
    }
  }

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration;

  bool get stepBackwardAvailable => _currentIndex > 0;

  void stepBackward() {
    if (!stepBackwardAvailable) return;
    playhead = _currentSpanStart - _spans[_currentIndex - 1].duration;
  }

  bool get stepForwardAvailable => _currentIndex < _spans.length - 1;

  void stepForward() {
    if (!stepForwardAvailable) return;
    playhead = _currentSpanEnd;
  }

  Duration startTimeOf(int index) {
    _validateIndex(index);
    return _spans
        .sublist(0, index)
        .fold(Duration.zero, (duration, span) => duration + span.duration);
  }

  Duration endTimeOf(int index) {
    _validateIndex(index);
    return startTimeOf(index) + _spans[index].duration;
  }

  void insert(int index, T span) {
    _validateIndex(index);
    _spans.insert(index, span);

    _totalDuration += span.duration;

    if (index <= _currentIndex) {
      _currentIndex++;
      _currentSpanStart += span.duration;
      _playhead += span.duration;
    }
  }

  void removeAt(int index) {
    _validateIndex(index);
    if (_spans.length <= 1) {
      throw Exception('Cannot remove last span in sequence.');
    }

    final removedDuration = _spans[index].duration;
    _spans.removeAt(index);

    _totalDuration -= removedDuration;

    if (index < _currentIndex) {
      _currentIndex--;
      _currentSpanStart -= removedDuration;
      _playhead -= removedDuration;
    } else if (index == _currentIndex) {
      _playhead = _currentSpanStart;

      if (_currentIndex == _spans.length) {
        _currentIndex--;
        _currentSpanStart -= _spans.last.duration;
      }
    }
  }
}
