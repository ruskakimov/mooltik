import 'dart:collection';

typedef AsyncTask = Future<void> Function();

/// Executes async functions in order.
/// TODO: Test this puppy
class TaskQueue {
  final queue = Queue<AsyncTask>();

  void add(AsyncTask task) {
    queue.add(task);
    if (!_isRunning) _run();
  }

  bool _isRunning = false;

  void _run() async {
    _isRunning = true;

    while (queue.isNotEmpty) {
      final task = queue.removeFirst();
      await task();
    }

    _isRunning = false;
  }
}
