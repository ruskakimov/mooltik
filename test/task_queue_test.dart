import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/task_queue.dart';

void main() {
  group('TaskQueue', () {
    test('runs a single task immediately', () {
      fakeAsync((async) {
        final q = TaskQueue();
        var done = false;

        q.add(() async {
          await Future.delayed(Duration(seconds: 5));
          done = true;
        });

        async.elapse(Duration(seconds: 5));
        expect(done, isTrue);
      });
    });

    test('runs two tasks consecutively', () {
      fakeAsync((async) {
        final q = TaskQueue();
        final s = clock.stopwatch()..start();
        final timestamps = [];

        q.add(() async {
          await Future.delayed(Duration(seconds: 5));
          timestamps.add(s.elapsed);
        });
        q.add(() async {
          await Future.delayed(Duration(seconds: 5));
          timestamps.add(s.elapsed);
        });

        async.elapse(Duration(seconds: 10));
        expect(timestamps, [Duration(seconds: 5), Duration(seconds: 10)]);

        s.stop();
      });
    });
  });
}
