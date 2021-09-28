import 'dart:ui';

/// A limited stack of historical snapshots for one frame.
class ImageHistoryStack {
  /// Creates a stack with [maxCount] maximum number of images.
  ///
  /// If [initialSnapshot] is `null`, it represents an empty canvas.
  ///
  /// Maximum number of consecutive undos would be `[maxCount] - 1`.
  ImageHistoryStack({
    required this.maxCount,
    Image? initialSnapshot,
  }) : _snapshots = [initialSnapshot?.clone()];

  /// Maximum number of historical snapshots in the stack.
  final int maxCount;

  /// List with historical snapshots.
  final List<Image?> _snapshots;

  int _currentSnapshotIndex = 0;

  /// Snapshot visible to the user.
  /// `null` represents an empty snapshot.
  Image? get currentSnapshot => _snapshots[_currentSnapshotIndex];

  /// Push a new [snapshot] in place of [currentSnapshot].
  void push(Image snapshot) {
    // Remove redo snapshots.
    if (isRedoAvailable) {
      final start = _currentSnapshotIndex + 1;
      final end = _snapshots.length;
      _snapshots.getRange(start, end).forEach((image) => image?.dispose());
      _snapshots.removeRange(start, end);
    }

    _snapshots.add(snapshot);

    // Remove oldest snapshots if the stack overflows.
    if (_snapshots.length > maxCount) {
      final start = 0;
      final end = _snapshots.length - maxCount;
      _snapshots.getRange(start, end).forEach((image) => image?.dispose());
      _snapshots.removeRange(start, end);
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

  void dispose() {
    // TODO: Check if current can be disposed too
    _snapshots.removeAt(_currentSnapshotIndex);
    _snapshots.forEach((image) => image?.dispose());
  }
}
