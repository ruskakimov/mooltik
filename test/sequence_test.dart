import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';

class TestSpan extends TimeSpan {
  TestSpan(Duration duration) : super(duration);

  @override
  TimeSpan copyWith({Duration? duration}) =>
      TestSpan(duration ?? this.duration);

  @override
  void dispose() {}
}

void main() {
  group('Sequence', () {
    test('playhead starts at zero', () {
      final seq = Sequence([
        TestSpan(Duration(seconds: 1)),
        TestSpan(Duration(seconds: 2)),
      ]);
      expect(seq.playhead, Duration.zero);
    });

    test('handles one span', () {
      final seq = Sequence([TestSpan(Duration(milliseconds: 200))]);
      expect(seq.totalDuration, Duration(milliseconds: 200));
    });

    test('calculates correct total', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 240)),
        TestSpan(Duration(milliseconds: 760)),
        TestSpan(Duration(seconds: 12)),
        TestSpan(Duration(milliseconds: 20)),
      ]);
      expect(
        seq.totalDuration,
        Duration(seconds: 13, milliseconds: 20),
      );
    });

    test('handles iteration', () {
      final list = [
        TestSpan(Duration(milliseconds: 111)),
        TestSpan(Duration(milliseconds: 333)),
        TestSpan(Duration(milliseconds: 555)),
      ];
      final seq = Sequence(list);

      for (int i = 0; i < seq.length; i++) {
        expect(seq[i], list[i]);
      }
    });

    test('ignores later mutations of provided list', () {
      final list = [
        TestSpan(Duration(milliseconds: 111)),
        TestSpan(Duration(milliseconds: 333)),
        TestSpan(Duration(milliseconds: 555)),
      ];
      final seq = Sequence(list);
      list.removeLast();
      expect(seq.length, 3);
    });

    test('syncs playhead with current span', () {
      final seq = Sequence([
        TestSpan(Duration(seconds: 1)),
        TestSpan(Duration(seconds: 2)),
        TestSpan(Duration(milliseconds: 200)),
      ]);
      expect(seq.playhead, Duration.zero);
      expect(seq.currentIndex, 0);
      seq.playhead = Duration(seconds: 1, milliseconds: 400);
      expect(seq.currentIndex, 1);
      seq.playhead = Duration(seconds: 3, milliseconds: 100);
      expect(seq.currentIndex, 2);
    });

    test('latest time span takes precedence when playhead is between', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 123)),
        TestSpan(Duration(milliseconds: 245)),
      ]);
      seq.playhead = Duration(milliseconds: 123);
      expect(seq.currentIndex, 1);
    });

    test('setting index jumps to that span\'s start time', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 120)),
        TestSpan(Duration(milliseconds: 240)),
      ]);
      seq.currentIndex = 1;
      expect(seq.playhead, Duration(milliseconds: 120));
    });

    test('handles inserting at current index', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 120)),
        TestSpan(Duration(milliseconds: 260)),
      ]);
      seq.playhead = Duration(milliseconds: 100);
      expect(seq.currentIndex, 0);
      seq.insert(0, TestSpan(Duration(milliseconds: 60)));
      expect(seq.length, 3);
      expect(seq.currentIndex, 1);
      expect(seq.playhead, Duration(milliseconds: 160));
    });

    test('handles removing current span', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 100)),
        TestSpan(Duration(milliseconds: 200)),
        TestSpan(Duration(milliseconds: 300)),
      ]);
      seq.playhead = Duration(milliseconds: 150);
      expect(seq.currentIndex, 1);
      seq.removeAt(1);
      expect(seq.playhead, Duration(milliseconds: 100));
      expect(seq.currentIndex, 1);
      expect(seq.length, 2);
    });

    test('handles replacing current span with longer one', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 100)),
        TestSpan(Duration(milliseconds: 200)),
        TestSpan(Duration(milliseconds: 300)),
      ]);
      seq.playhead = Duration(milliseconds: 150);
      expect(seq.currentIndex, 1);
      expect(seq.totalDuration, Duration(milliseconds: 600));
      seq[1] = TestSpan(Duration(milliseconds: 500));
      expect(seq.currentIndex, 1);
      expect(seq.playhead, Duration(milliseconds: 150));
      expect(seq.totalDuration, Duration(milliseconds: 900));
    });

    test('handles replacing current span with shorter one', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 100)),
        TestSpan(Duration(milliseconds: 200)),
        TestSpan(Duration(milliseconds: 300)),
      ]);
      seq.playhead = Duration(milliseconds: 150);
      expect(seq.currentIndex, 1);
      expect(seq.totalDuration, Duration(milliseconds: 600));
      seq[1] = TestSpan(Duration(milliseconds: 20));
      expect(seq.currentIndex, 2);
      expect(seq.playhead, Duration(milliseconds: 150));
      expect(seq.totalDuration, Duration(milliseconds: 420));
    });

    test('handles replacing span before current with shorter one', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 740)),
        TestSpan(Duration(milliseconds: 160)),
        TestSpan(Duration(milliseconds: 100)),
      ]);
      seq.playhead = Duration(milliseconds: 800);
      expect(seq.currentIndex, 1);
      expect(seq.totalDuration, Duration(milliseconds: 1000));
      seq[0] = TestSpan(Duration(milliseconds: 20));
      expect(seq.currentIndex, 2);
      expect(seq.playhead, Duration(milliseconds: 800));
      expect(seq.totalDuration, Duration(milliseconds: 280));
    });

    test('handles replacing span before current with longer one', () {
      final seq = Sequence([
        TestSpan(Duration(milliseconds: 760)),
        TestSpan(Duration(milliseconds: 140)),
        TestSpan(Duration(milliseconds: 100)),
      ]);
      seq.playhead = Duration(milliseconds: 800);
      expect(seq.currentIndex, 1);
      expect(seq.totalDuration, Duration(milliseconds: 1000));
      seq[0] = TestSpan(Duration(seconds: 5));
      expect(seq.currentIndex, 0);
      expect(seq.playhead, Duration(milliseconds: 800));
      expect(seq.totalDuration, Duration(seconds: 5, milliseconds: 240));
    });
  });
}
