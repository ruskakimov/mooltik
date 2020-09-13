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

class Frame extends ChangeNotifier {
  Frame() : _strokes = [];

  final List<Stroke> _strokes;

  /// Must contain at least one snapshot. [null] represents an empty screen.
  List<ui.Image> _snapshots = [null];

  int _selectedSnapshotId = 0;
  int _rasterisedUntil = 0;

  bool _lastStrokeTouchesFrame;

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

  void startPencilStroke(Offset startPoint) {
    startStroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = Colors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
    );
  }

  void startEraserStroke(Offset startPoint) {
    startStroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.clear,
    );
  }

  void startStroke(Offset startPoint, Paint strokePaint) {
    _strokes.add(Stroke(startPoint, strokePaint));

    final markArea = Rect.fromCenter(
      center: startPoint,
      width: strokePaint.strokeWidth,
      height: strokePaint.strokeWidth,
    );
    _lastStrokeTouchesFrame = markArea.overlaps(_frameArea);

    notifyListeners();
  }

  void extendLastStroke(Offset point) {
    _strokes.last.extend(point);

    if (!_lastStrokeTouchesFrame) {
      final markArea = Rect.fromCenter(
        center: point,
        width: _strokes.last.paint.strokeWidth,
        height: _strokes.last.paint.strokeWidth,
      );
      _lastStrokeTouchesFrame = markArea.overlaps(_frameArea);
    }

    notifyListeners();
  }

  void finishLastStroke() {
    if (_strokes.isEmpty) return;

    _strokes.last.finish();

    if (_lastStrokeTouchesFrame) {
      _generateLastSnapshot();
    } else {
      cancelLastStroke();
    }
  }

  void cancelLastStroke() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
    }
    notifyListeners();
  }

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

    _rasterisedUntil = _strokes.length;
    notifyListeners();
  }

  void paintOn(Canvas canvas) {
    canvas.drawColor(Colors.white, BlendMode.srcOver);

    // Save layer to erase paintings on it with `BlendMode.clear`.
    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());

    if (snapshot != null) {
      canvas.drawImage(snapshot, Offset.zero, Paint());
    }

    for (int i = _rasterisedUntil; i < _strokes.length; i++) {
      _strokes[i].paintOn(canvas);
    }

    // Flatten layer. Combine drawing lines with erasing lines.
    canvas.restore();
  }
}
