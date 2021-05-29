import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/selection_stroke.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';

class LassoModel extends ChangeNotifier {
  LassoModel(EaselModel easel) : _easel = easel {
    _easel.addListener(() {
      if (_easel.selectedTool is! Lasso) _finishTransformMode();
      notifyListeners();
    });
  }

  EaselModel _easel;

  void updateEasel(EaselModel easel) {
    _easel = easel;
    notifyListeners();
  }

  SelectionStroke get selectionStroke => _easel.selectionStroke;

  Offset get selectionOffset =>
      selectionStroke.boundingRect.topLeft * _easel.scale;

  Matrix4 get _selectionPathTransform => Matrix4.identity()
    ..scale(_easel.scale)
    ..translate(
      -selectionStroke.boundingRect.left,
      -selectionStroke.boundingRect.top,
    );

  Path get selectionPath =>
      selectionStroke.path.transform(_selectionPathTransform.storage);

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

  /// Erases original image and transforms a copy.
  void transformSelection() {
    if (!finishedSelection) return;
    _launchTransformMode();
    _eraseSelection();
    _easel.removeSelection();
    notifyListeners();
  }

  void _launchTransformMode() {
    _isTransformMode = true;
    _transformBoxCenterOffset = selectionStroke.boundingRect.center;
    _transformBoxSize = selectionStroke.boundingRect.size;
    // TODO: Store masked image
  }

  void _finishTransformMode() {
    _isTransformMode = false;
    // TODO: Paste positioned masked image
    // TODO: Remove snapshot with erased selection
    _transformBoxCenterOffset = null;
    _transformBoxSize = null;
  }

  /// Keeps original image and transforms a copy.
  void duplicateSelection() {
    if (!finishedSelection) return;
    _launchTransformMode();
    _easel.removeSelection();
    notifyListeners();
  }

  /// Fills selection with selected color.
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

  /// Erases all paint within selection.
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
