import 'dart:ui' as ui;

import 'package:mooltik/editor/frame/frame_painter.dart';
import 'package:flutter/material.dart';

import 'stroke.dart';

/// Maximum number of stored snapshots.
///
/// Each stroke generates a new snapshot.
/// Snapshot is a bitmap image.
/// This value minus 1 equals maximum number of undo's.
const int maxSnapshotCount = 16;

class FrameModel extends ChangeNotifier {
  FrameModel({
    @required this.id,
    @required Size size,
    int duration = 1,
    ui.Image initialSnapshot,
  })  : _size = size,
        _duration = duration,
        unrasterizedStrokes = [],
        _snapshots = [initialSnapshot],
        _selectedSnapshotId = 0;

  final int id;

  int get duration => _duration;
  int _duration;
  set duration(int value) {
    if (value <= 0) return;
    _duration = value;
    notifyListeners();
  }

  final List<Stroke> unrasterizedStrokes;

  /// Must contain at least one snapshot. [null] represents an empty screen.
  List<ui.Image> _snapshots;
  int _selectedSnapshotId;

  final Size _size;

  double get width => _size.width;

  double get height => _size.height;

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

  void add(Stroke stroke) {
    unrasterizedStrokes.add(stroke);
    _generateLastSnapshot();
  }

  Future<void> _generateLastSnapshot() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    FramePainter(
      frame: this,
      background: Colors.transparent,
    ).paint(canvas, ui.Size(width, height));
    final pic = recorder.endRecording();
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
