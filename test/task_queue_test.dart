import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/task_queue.dart';

void main() {
  group('TaskQueue', () {
    test('runs a single task immediately', () {
      final q = TaskQueue();
      final s = Stopwatch();
      q.add(() async {
        s.stop();
        expect(s.elapsed, Duration.zero);
      });
    });
  });
}
