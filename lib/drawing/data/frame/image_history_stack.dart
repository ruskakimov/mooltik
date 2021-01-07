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
  List<Image> _snapshots;

  int _currentSnapshotIndex;

  /// Snapshot visible to the user.
  Image get currentSnapshot => _snapshots[_currentSnapshotIndex];

  /// Push a new [snapshot] in place of [currentSnapshot].
  void push(Image snapshot) {}

  /// Select previous snapshot if available.
  void undo() {}

  /// Select next snapshot if available.
  void redo() {}
}
