import 'dart:ui';

import 'package:flutter/foundation.dart';

/// A limited stack of historical snapshots for one frame.
class ImageHistoryStack {
  ImageHistoryStack({
    @required this.maxCount,
  });

  /// Maximum number of historical snapshots in the stack.
  final int maxCount;

  /// List with historical snapshots.
  final List<Image> _snapshots = [];

  int _currentSnapshotIndex = 0;

  /// Snapshot visible to the user.
  Image get currentSnapshot =>
      _snapshots.isNotEmpty ? _snapshots[_currentSnapshotIndex] : null;

  /// Push a new [snapshot] in place of [currentSnapshot].
  void push(Image snapshot) {
    // Remove redo snapshots.
    if (isRedoAvailable) {
      _snapshots.removeRange(_currentSnapshotIndex + 1, _snapshots.length);
    }

    _snapshots.add(snapshot);

    // Remove oldest snapshots if the stack overflows.
    if (_snapshots.length > maxCount) {
      _snapshots.removeRange(0, _snapshots.length - maxCount);
    }

    // Select pushed snapshot.
    _currentSnapshotIndex = _snapshots.length - 1;
  }

  /// Whether there is an older snapshot available.
  bool get isUndoAvailable => _currentSnapshotIndex > 0;

  /// Select older snapshot if available.
  void undo() {
    if (isUndoAvailable) {
      _currentSnapshotIndex--;
    }
  }

  /// Whether there is a newer snapshot available.
  bool get isRedoAvailable => _currentSnapshotIndex < _snapshots.length - 1;

  /// Select newer snapshot if available.
  void redo() {
    if (isRedoAvailable) {
      _currentSnapshotIndex++;
    }
  }
}
