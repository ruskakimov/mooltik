import 'dart:ui' as ui;

import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/image_history_stack.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

import 'stroke.dart';

class FrameModel extends ChangeNotifier {
  FrameModel({
    int id,
    @required Size size,
    Duration duration = const Duration(seconds: 1),
    ui.Image initialSnapshot,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch,
        _size = size,
        _duration = duration,
        unrasterizedStrokes = [],
        _historyStack = ImageHistoryStack(
          maxCount: 16,
          initialSnapshot: initialSnapshot,
        );

  final int id;

  Duration get duration => _duration;
  Duration _duration;
  set duration(Duration value) {
    if (value <= Duration.zero) return;
    _duration = value;
    notifyListeners();
  }

  final List<Stroke> unrasterizedStrokes;

  final ImageHistoryStack _historyStack;

  Size get size => _size;
  final Size _size;

  double get width => _size.width;

  double get height => _size.height;

  ui.Image get snapshot => _historyStack.currentSnapshot;

  bool get undoAvailable => _historyStack.isUndoAvailable;

  bool get redoAvailable => _historyStack.isRedoAvailable;

  void undo() {
    _historyStack.undo();
    notifyListeners();
  }

  void redo() {
    _historyStack.redo();
    notifyListeners();
  }

  void add(Stroke stroke) {
    unrasterizedStrokes.add(stroke);
    _generateLastSnapshot();
  }

  Future<void> _generateLastSnapshot() async {
    final snapshot = await generateImage(
      FramePainter(
        frame: this,
        strokes: unrasterizedStrokes,
        background: Colors.transparent,
      ),
      width.toInt(),
      height.toInt(),
    );
    _historyStack.push(snapshot);
    unrasterizedStrokes.clear();
    notifyListeners();
  }
}
