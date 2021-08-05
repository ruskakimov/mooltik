import 'dart:collection';

typedef AsyncTask = Future<void> Function();

/// Executes async functions in order.
class TaskQueue {
  final _queue = Queue<AsyncTask>();

  void add(AsyncTask task) {
    _queue.add(task);
    if (!_isRunning) _run();
  }

  bool _isRunning = false;

  void _run() async {
    _isRunning = true;

    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      await task();
    }

    _isRunning = false;
  }
}
