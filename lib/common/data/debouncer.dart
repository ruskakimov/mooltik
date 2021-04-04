import 'dart:async';

import 'package:flutter/material.dart';

/// Manages a single debounce task.
class Debouncer {
  Debouncer(this.timeout);

  final Duration timeout;
  Timer _timer;

  void debounce(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(timeout, callback);
  }
}
