import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

class TestSpan extends TimeSpan {
  TestSpan(this.duration);

  final Duration duration;
}

void main() {
  group('Sequence', () {
    test('returns correct total duration for one span', () {
      final seq = Sequence([TestSpan(Duration(milliseconds: 200))]);
      expect(seq.totalDuration, Duration(milliseconds: 200));
    });
  });
}
