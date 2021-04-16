import 'dart:async';

import 'package:flutter/material.dart';

/// Manages a single debounce timer.
class Debouncer {
  Debouncer(this.timeout);

  final Duration timeout;
  Timer _timer;

  bool get isActive => _timer?.isActive ?? false;

  void debounce(VoidCallback callback) {
    cancel();
    _timer = Timer(timeout, callback);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
