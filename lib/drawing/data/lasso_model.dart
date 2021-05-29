import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/selection_stroke.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

class LassoModel extends ChangeNotifier {
  LassoModel(EaselModel easel) : _easel = easel;

  EaselModel _easel;

  void updateEasel(EaselModel easel) {
    _easel = easel;
    notifyListeners();
  }

  SelectionStroke get selectionStroke => _easel.selectionStroke;

  bool get showLassoMenu =>
      _easel.selectedTool is Lasso && finishedSelection && !isTransformMode;

  bool get finishedSelection => selectionStroke?.finished ?? false;

  bool get isTransformMode => _isTransformMode;
  bool _isTransformMode = false;

  Offset get transformBoxCenterOffset =>
      _transformBoxCenterOffset * _easel.scale;
  Offset _transformBoxCenterOffset;

  Size get transformBoxSize => _transformBoxSize * _easel.scale;
  Size _transformBoxSize;

  // ===================
  // Lasso menu methods:
  // ===================

  void transformSelection() {
    if (!finishedSelection) return;
    _launchTransformMode();
    _eraseSelection();
    _easel.removeSelection();
    notifyListeners();
  }

  void _launchTransformMode() {
    _isTransformMode = true;
    _transformBoxCenterOffset = _easel.selectionStroke.boundingRect.center;
    _transformBoxSize = _easel.selectionStroke.boundingRect.size;
    // TODO: Store masked image
  }

  void duplicateSelection() {
    if (!finishedSelection) return;
    _launchTransformMode();
    _easel.removeSelection();
    notifyListeners();
  }

  void fillSelection() {
    if (!finishedSelection) return;
    _fillSelection();
    _easel.removeSelection();
    notifyListeners();
  }

  void _fillSelection() {
    final fillColor = (_easel.selectedTool as Lasso).color;
    selectionStroke.setColorPaint(fillColor);
    _applySelectionStrokeToFrame();
  }

  void eraseSelection() {
    if (!finishedSelection) return;
    _eraseSelection();
    _easel.removeSelection();
    notifyListeners();
  }

  void _eraseSelection() {
    selectionStroke.setErasingPaint();
    _applySelectionStrokeToFrame();
  }

  void _applySelectionStrokeToFrame() async {
    final snapshot = await generateImage(
      FramePainter(frame: _easel.frame, strokes: [selectionStroke]),
      _easel.frame.width.toInt(),
      _easel.frame.height.toInt(),
    );
    _easel.pushSnapshot(snapshot);
  }
}
