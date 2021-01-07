import 'dart:ui';

import 'package:flutter/foundation.dart';

/// A stack of image progression with maximum length.
class ImageHistoryStack {
  ImageHistoryStack({
    @required this.maxCount,
  });

  /// Maximum number of images in the stack.
  final int maxCount;

  /// List with image progression.
  final List<Image> _snapshots = [];

  int _currentSnapshotIndex;

  /// Snapshot visible to the user.
  Image get currentSnapshot =>
      _snapshots.isNotEmpty ? _snapshots[_currentSnapshotIndex] : null;

  /// Push a new [snapshot] in place of [currentSnapshot].
  void push(Image snapshot) {}

  /// Whether there is an older snapshot available.
  bool get isUndoAvailable => true;

  /// Select older snapshot if available.
  void undo() {}

  /// Whether there is a newer snapshot available.
  bool get isRedoAvailable => true;

  /// Select newer snapshot if available.
  void redo() {}
}
