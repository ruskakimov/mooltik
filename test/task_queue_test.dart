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
      final q = TaskQueue();
      q.add(() async {});
      q.add(() async {});
    });
  });
}
