import 'dart:ui' as ui;

import 'package:mooltik/editor/gif.dart' show pictureFromFrame;
import 'package:flutter/material.dart';

import 'stroke.dart';

/// Maximum number of stored snapshots.
///
/// Each stroke generates a new snapshot.
/// Snapshot is a bitmap image.
/// This value minus 1 equals maximum number of undo's.
const int maxSnapshotCount = 16;

class FrameModel extends ChangeNotifier {
  FrameModel(this.number, {ui.Image initialSnapshot})
      : unrasterizedStrokes = [],
        _snapshots = [initialSnapshot],
        _selectedSnapshotId = 0;

  final int number;
  final List<Stroke> unrasterizedStrokes;

  bool _lastStrokeTouchesFrame;

  /// Must contain at least one snapshot. [null] represents an empty screen.
  List<ui.Image> _snapshots;
  int _selectedSnapshotId;

  double get width => 1280;

  double get height => 720;

  Rect get _frameArea => Rect.fromLTWH(0, 0, width, height);

  ui.Image get snapshot => _snapshots[_selectedSnapshotId];

  bool get undoAvailable => _selectedSnapshotId > 0;

  bool get redoAvailable => _selectedSnapshotId + 1 < _snapshots.length;

  void undo() {
    if (undoAvailable) {
      _selectedSnapshotId--;
      notifyListeners();
    }
  }

  void redo() {
    if (redoAvailable) {
      _selectedSnapshotId++;
      notifyListeners();
    }
  }

  // void startStroke(Offset startPoint, Paint strokePaint) {
  //   unrasterizedStrokes.add(Stroke(startPoint, strokePaint));

  //   final markArea = Rect.fromCenter(
  //     center: startPoint,
  //     width: strokePaint.strokeWidth,
  //     height: strokePaint.strokeWidth,
  //   );
  //   _lastStrokeTouchesFrame = markArea.overlaps(_frameArea);

  //   notifyListeners();
  // }

  // void extendLastStroke(Offset point) {
  //   if (unrasterizedStrokes.isEmpty) return;

  //   unrasterizedStrokes.last.extend(point);

  //   if (!_lastStrokeTouchesFrame) {
  //     final markArea = Rect.fromCenter(
  //       center: point,
  //       width: unrasterizedStrokes.last.paint.strokeWidth,
  //       height: unrasterizedStrokes.last.paint.strokeWidth,
  //     );
  //     _lastStrokeTouchesFrame = markArea.overlaps(_frameArea);
  //   }

  //   notifyListeners();
  // }

  // void finishLastStroke() {
  //   if (unrasterizedStrokes.isEmpty) return;

  //   unrasterizedStrokes.last.finish();

  //   if (_lastStrokeTouchesFrame) {
  //     _generateLastSnapshot();
  //   } else {
  //     cancelLastStroke();
  //   }
  // }

  void add(Stroke stroke) {
    // TODO: Check if touches the frame area
    unrasterizedStrokes.add(stroke);
    _generateLastSnapshot();
  }

  // void cancelLastStroke() {
  //   if (unrasterizedStrokes.isNotEmpty) {
  //     unrasterizedStrokes.removeLast();
  //   }
  //   notifyListeners();
  // }

  Future<void> _generateLastSnapshot() async {
    final pic = pictureFromFrame(this);
    final snapshot = await pic.toImage(width.toInt(), height.toInt());

    // Remove redoable snapshots on new stroke.
    if (_selectedSnapshotId >= 0) {
      _snapshots.removeRange(_selectedSnapshotId + 1, _snapshots.length);
    }

    _snapshots.add(snapshot);
    if (_snapshots.length > maxSnapshotCount) {
      _snapshots.removeRange(0, _snapshots.length - maxSnapshotCount);
    }
    _selectedSnapshotId = _snapshots.length - 1;

    unrasterizedStrokes.clear();
    notifyListeners();
  }
}
