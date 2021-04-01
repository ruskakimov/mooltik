import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/drawing/data/frame/image_history_stack.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

/// Maximum number of consecutive undos.
const int maxUndos = 50;

const twoPi = pi * 2;

class EaselModel extends ChangeNotifier {
  EaselModel({
    @required FrameModel frame,
    @required this.frameSize,
    @required Tool selectedTool,
  })  : _frame = frame,
        _historyStack = ImageHistoryStack(
          maxCount: maxUndos + 1,
          initialSnapshot: frame.snapshot,
        ),
        _selectedTool = selectedTool;

  FrameModel _frame;

  Tool _selectedTool;

  final Size frameSize;

  Size _easelSize;

  Offset _offset = Offset.zero;

  double _rotation = 0;
  double _prevRotation = 0;

  double _scale = 1;
  double _prevScale;

  Offset _fixedFramePoint;

  /// Current strokes that are not yet rasterized and added to the frame.
  final List<Stroke> unrasterizedStrokes = [];

  ImageHistoryStack _historyStack;

  /// Canvas offset from top of the easel area.
  double get canvasTopOffset => _offset.dy;

  /// Canvas offset from left of the easel area.
  double get canvasLeftOffset => _offset.dx;

  /// Canvas rotation with top left as the anchor point.
  double get canvasRotation => _rotation;

  /// Canvas width at current scale.
  double get canvasWidth => frameSize.width * _scale;

  /// Canvas height at current scale.
  double get canvasHeight => frameSize.height * _scale;

  Rect get _frameArea => Rect.fromLTWH(0, 0, frameSize.width, frameSize.height);

  /// Used by provider to update dependency.
  void updateSelectedTool(Tool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  /// Used by provider to update dependency.
  void updateFrame(FrameModel frame) {
    if (frame.file == _frame.file) return;
    _frame = frame;
    _historyStack = ImageHistoryStack(
      maxCount: maxUndos + 1,
      initialSnapshot: frame.snapshot,
    );
    notifyListeners();
  }

  /// Updates easel size on first build and when easel size changes.
  void updateSize(Size size) {
    if (size == _easelSize) return;

    if (_easelSize != size) {
      _easelSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fitToScreen();
      });
    } else {
      _easelSize = size;
    }
  }

  bool get undoAvailable => _historyStack.isUndoAvailable;

  bool get redoAvailable => _historyStack.isRedoAvailable;

  void undo() {
    _historyStack.undo();
    _frame.snapshot = _historyStack.currentSnapshot;
    notifyListeners();
  }

  void redo() {
    _historyStack.redo();
    _frame.snapshot = _historyStack.currentSnapshot;
    notifyListeners();
  }

  void fitToScreen() {
    if (_easelSize == null) return;
    _scale = min(
      _easelSize.height / frameSize.height,
      _easelSize.width / frameSize.width,
    );
    _offset = Offset(
      (_easelSize.width - frameSize.width * _scale) / 2,
      (_easelSize.height - frameSize.height * _scale) / 2,
    );
    _rotation = 0;
    notifyListeners();
  }

  Offset _toFramePoint(Offset point) {
    final p = (point - _offset) / _scale;
    return Offset(
      p.dx * cos(_rotation) + p.dy * sin(_rotation),
      -p.dx * sin(_rotation) + p.dy * cos(_rotation),
    );
  }

  Offset _calcOffsetToMatchPoints(Offset framePoint, Offset screenPoint) {
    final a = screenPoint.dx;
    final b = screenPoint.dy;
    final c = framePoint.dx;
    final d = framePoint.dy;
    final si = sin(_rotation);
    final co = cos(_rotation);
    final ta = si / co;
    final s = _scale;

    final e = -d * s - a * si + b * co;
    final f = -c * s + a * co + b * si;

    final x = (f - e * ta) / (co + si * ta);
    final y = (e + x * si) / co;

    return Offset(x, y);
  }

  void onScaleStart(ScaleStartDetails details) {
    _prevScale = _scale;
    _prevRotation = _rotation;
    _fixedFramePoint = _toFramePoint(details.localFocalPoint);
    notifyListeners();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    _scale = (_prevScale * details.scale).clamp(0.1, 8.0);
    _rotation = (_prevRotation + details.rotation) % twoPi;
    _offset =
        _calcOffsetToMatchPoints(_fixedFramePoint, details.localFocalPoint);
    notifyListeners();
  }

  void onStrokeStart(DragStartDetails details) {
    final framePoint = _toFramePoint(details.localPosition);
    unrasterizedStrokes.add(
      _selectedTool.makeStroke(framePoint),
    );
    notifyListeners();
  }

  void onStrokeUpdate(DragUpdateDetails details) {
    if (unrasterizedStrokes.isEmpty) return;

    final framePoint = _toFramePoint(details.localPosition);
    unrasterizedStrokes.last.extend(framePoint);
    notifyListeners();
  }

  void onStrokeEnd() {
    if (unrasterizedStrokes.isEmpty) return;

    unrasterizedStrokes.last.finish();

    // TODO: Queue snapshots.
    if (unrasterizedStrokes.last.boundingRect.overlaps(_frameArea)) {
      _generateLastSnapshot();
    }

    notifyListeners();
  }

  void onStrokeCancel() {
    if (unrasterizedStrokes.isEmpty) return;

    unrasterizedStrokes.removeLast();
    notifyListeners();
  }

  Future<void> _generateLastSnapshot() async {
    final snapshot = await generateImage(
      FramePainter(
        frame: _frame,
        strokes: unrasterizedStrokes,
        background: Colors.transparent,
      ),
      _frame.width.toInt(),
      _frame.height.toInt(),
    );
    _frame.snapshot = snapshot;
    _historyStack.push(snapshot);
    unrasterizedStrokes.clear();
    notifyListeners();
  }
}
