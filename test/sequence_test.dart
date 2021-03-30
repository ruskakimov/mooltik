import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

class TestSpan extends TimeSpan {
  TestSpan(this.duration);

  final Duration duration;
}

void main() {
  group('Sequence', () {
    test('handles one span', () {
      final seq = Sequence([TestSpan(Duration(milliseconds: 200))]);
      expect(seq.totalDuration, Duration(milliseconds: 200));
    });

    test('calculates correct total', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 250)),
        TestSpan(Duration(milliseconds: 750)),
        TestSpan(Duration(seconds: 12)),
        TestSpan(Duration(milliseconds: 24)),
      ]);
      expect(
        seq.totalDuration,
        Duration(seconds: 13, milliseconds: 24),
      );
    });
  });
}
