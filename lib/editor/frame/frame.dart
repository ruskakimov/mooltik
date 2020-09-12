import 'dart:ui' as ui;

import 'package:mooltik/editor/gif.dart' show pictureFromFrame;
import 'package:flutter/material.dart';

import 'stroke.dart';

class Frame extends ChangeNotifier {
  Frame() : _strokes = [];

  final List<Stroke> _strokes;

  List<ui.Image> _snapshots = [];
  int _selectedSnapshotId = -1;
  int _rasterisedUntil = 0;

  double get width => 1280;

  double get height => 720;

  bool get undoAvailable => _selectedSnapshotId >= 0;

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
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = Colors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5),
    ));
    notifyListeners();
  }

  void startEraserStroke(Offset startPoint) {
    _strokes.add(Stroke(
      startPoint,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.clear,
    ));
    notifyListeners();
  }

  void extendLastStroke(Offset point) {
    _strokes.last.extend(point);
    notifyListeners();
  }

  void finishLastStroke() {
    if (_strokes.isNotEmpty) {
      _strokes.last.finish();
      _rasterize();
    }
    notifyListeners();
  }

  void cancelLastStroke() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
    }
    notifyListeners();
  }

  Future<void> _rasterize() async {
    final pic = pictureFromFrame(this);
    final snapshot = await pic.toImage(width.toInt(), height.toInt());

    // Remove redoable snapshots on new stroke.
    if (_selectedSnapshotId >= 0) {
      _snapshots.removeRange(_selectedSnapshotId + 1, _snapshots.length);
    }

    _snapshots.add(snapshot);
    _selectedSnapshotId = _snapshots.length - 1;

    _rasterisedUntil = _strokes.length;
    notifyListeners();
  }

  void paintOn(Canvas canvas) {
    canvas.drawColor(Colors.white, BlendMode.srcOver);

    // Save layer to erase paintings on it with `BlendMode.clear`.
    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());

    if (_selectedSnapshotId >= 0) {
      canvas.drawImage(_snapshots[_selectedSnapshotId], Offset.zero, Paint());
    }

    for (int i = _rasterisedUntil; i < _strokes.length; i++) {
      _strokes[i].paintOn(canvas);
    }

    // Flatten layer. Combine drawing lines with erasing lines.
    canvas.restore();
  }
}
