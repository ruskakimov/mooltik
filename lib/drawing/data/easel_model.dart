import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/debouncer.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame/image_history_stack.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:mooltik/drawing/data/toolbox/tools/brush.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Maximum number of consecutive undos.
const int maxUndos = 50;

/// No changes for this time period would trigger write to disk.
const Duration diskWriteTimeout = Duration(seconds: 2);

const twoPi = pi * 2;

const _allowDrawingWithFingerKey = 'allow_drawing_with_finger';

class EaselModel extends ChangeNotifier {
  EaselModel({
    @required Frame frame,
    @required Tool selectedTool,
    @required this.onChanged,
    @required SharedPreferences sharedPreferences,
  })  : assert(sharedPreferences != null),
        _frame = frame,
        _historyStack = ImageHistoryStack(
          maxCount: maxUndos + 1,
          initialSnapshot: frame.snapshot,
        ),
        _selectedTool = selectedTool,
        _preferences = sharedPreferences,
        _allowDrawingWithFinger =
            sharedPreferences.getBool(_allowDrawingWithFingerKey) ?? true;

  Frame get frame => _frame;
  Frame _frame;

  Tool _selectedTool;

  final ValueChanged<Frame> onChanged;

  Size get frameSize => _frame.size;

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

  final Debouncer _diskWriteDebouncer = Debouncer(diskWriteTimeout);

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
  void updateFrame(Frame frame) {
    if (frame.file == _frame.file) return;

    if (_diskWriteDebouncer.isActive) {
      _diskWriteDebouncer.cancel();
      _frame.saveSnapshot();
    }

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
    _updateFrame();
    notifyListeners();
  }

  void redo() {
    _historyStack.redo();
    _updateFrame();
    notifyListeners();
  }

  void _updateFrame() {
    _frame = _frame.copyWith(snapshot: _historyStack.currentSnapshot);
    _diskWriteDebouncer.debounce(() => _frame.saveSnapshot());
    onChanged(_frame);
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

    if (_selectedTool is Brush) {
      final stroke = Stroke(framePoint, (_selectedTool as Brush).paint);
      unrasterizedStrokes.add(stroke);
    }
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

    if (unrasterizedStrokes.last.boundingRect.overlaps(_frameArea)) {
      _applyStrokes();
    } else {
      unrasterizedStrokes.removeLast();
    }

    notifyListeners();
  }

  void onStrokeCancel() {
    if (unrasterizedStrokes.isEmpty) return;

    unrasterizedStrokes.removeLast();
    notifyListeners();
  }

  Future<void> _applyStrokes() async {
    final newSnapshot = await _generateLastSnapshot();
    unrasterizedStrokes.clear();
    pushSnapshot(newSnapshot);
  }

  Future<ui.Image> _generateLastSnapshot() async {
    final snapshot = await generateImage(
      FramePainter(frame: _frame, strokes: unrasterizedStrokes),
      _frame.width.toInt(),
      _frame.height.toInt(),
    );
    return snapshot;
  }

  void pushSnapshot(ui.Image snapshot) {
    _historyStack.push(snapshot);
    _updateFrame();
    notifyListeners();
  }

  // ==================
  // Easel preferences:
  // ==================

  SharedPreferences _preferences;

  bool get allowDrawingWithFinger => _allowDrawingWithFinger ?? true;
  bool _allowDrawingWithFinger;

  Future<void> toggleDrawingWithFinger() async {
    _allowDrawingWithFinger = !_allowDrawingWithFinger;
    notifyListeners();

    await _preferences.setBool(
      _allowDrawingWithFingerKey,
      _allowDrawingWithFinger,
    );
  }
}
