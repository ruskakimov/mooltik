import 'dart:ui';

import 'package:flutter/foundation.dart';

/// A limited stack of historical snapshots.
class ImageHistoryStack {
  ImageHistoryStack({
    @required this.maxCount,
  });

  /// Maximum number of historical snapshots in the stack.
  final int maxCount;

  /// List with historical snapshots.
  final List<Image> _snapshots = [];

  int _currentSnapshotIndex;

  /// Snapshot visible to the user.
  Image get currentSnapshot =>
      _snapshots.isNotEmpty ? _snapshots[_currentSnapshotIndex] : null;

  /// Push a new [snapshot] in place of [currentSnapshot].
  void push(Image snapshot) {}

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
