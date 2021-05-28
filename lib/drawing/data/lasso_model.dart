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

  bool get showLassoMenu => _easel.selectedTool is Lasso && finishedSelection;

  bool get finishedSelection => selectionStroke?.finished ?? false;

  // ===================
  // Lasso menu methods:
  // ===================

  void transformSelection() {
    if (!finishedSelection) return;
    // TODO: Implement
    _easel.removeSelection();
    notifyListeners();
  }

  void duplicateSelection() {
    if (!finishedSelection) return;
    // TODO: Implement
    _easel.removeSelection();
    notifyListeners();
  }

  void fillSelection() {
    if (!finishedSelection) return;
    _pushFilledSelectionSnapshot();
    _easel.removeSelection();
    notifyListeners();
  }

  void eraseSelection() {
    if (!finishedSelection) return;
    _pushErasedSelectionSnapshot();
    _easel.removeSelection();
    notifyListeners();
  }

  void _pushFilledSelectionSnapshot() async {
    final fillColor = (_easel.selectedTool as Lasso).color;
    selectionStroke.setColorPaint(fillColor);

    final snapshot = await generateImage(
      FramePainter(frame: _easel.frame, strokes: [selectionStroke]),
      _easel.frame.width.toInt(),
      _easel.frame.height.toInt(),
    );
    _easel.pushSnapshot(snapshot);
  }

  void _pushErasedSelectionSnapshot() async {
    selectionStroke.setErasingPaint();

    final snapshot = await generateImage(
      FramePainter(frame: _easel.frame, strokes: [selectionStroke]),
      _easel.frame.width.toInt(),
      _easel.frame.height.toInt(),
    );
    _easel.pushSnapshot(snapshot);
  }
}
