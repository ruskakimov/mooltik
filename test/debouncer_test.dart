import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/debouncer.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  group('Debouncer', () {
    test('handles single call', () {
      fakeAsync((async) {
        final d = Debouncer(Duration(seconds: 2));
        final s = Stopwatch();
        s.start();
        d.debounce(() {
          expect(s.elapsed, Duration(seconds: 2));
          s.stop();
        });
      });
    });

    test('handles multiple calls', () {
      fakeAsync((async) {
        final d = Debouncer(Duration(seconds: 2));
        final s = Stopwatch();
        s.start();
        int callbacksExecuted = 0;
        d.debounce(() => callbacksExecuted++);
        async.elapse(Duration(seconds: 1));
        d.debounce(() => callbacksExecuted++);
        async.elapse(Duration(seconds: 1));
        d.debounce(() {
          expect(callbacksExecuted, 0);
          expect(s.elapsed, Duration(seconds: 4));
          s.stop();
        });
      });
    });
  });
}
