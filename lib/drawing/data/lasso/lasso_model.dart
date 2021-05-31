import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:mooltik/drawing/data/frame/selection_stroke.dart';
import 'package:mooltik/drawing/data/lasso/masked_image_painter.dart';
import 'package:mooltik/drawing/data/toolbox/tools/tools.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:mooltik/drawing/ui/lasso/transformed_image_painter.dart';

class LassoModel extends ChangeNotifier {
  LassoModel({
    @required EaselModel easel,
    @required double headerHeight,
  })  : _easel = easel,
        _headerHeight = headerHeight {
    _easel.addListener(() {
      if (_easel.selectedTool is! Lasso) endTransformMode();
      notifyListeners();
    });
  }

  EaselModel _easel;

  /// For global point -> easel point conversion.
  double _headerHeight;

  void updateEasel(EaselModel easel) {
    _easel = easel;
    notifyListeners();
  }

  void updateHeaderHeight(double height) {
    _headerHeight = height;
    notifyListeners();
  }

  SelectionStroke get selectionStroke => _easel.selectionStroke;

  Offset get selectionOffset =>
      selectionStroke.boundingRect.topLeft * _easel.scale;

  Path get selectionPath =>
      selectionStroke.path.transform(_selectionPathTransform.storage);

  Matrix4 get _selectionPathTransform => Matrix4.identity()
    ..scale(_easel.scale)
    ..translate(
      -selectionStroke.boundingRect.left,
      -selectionStroke.boundingRect.top,
    );

  bool get finishedSelection => selectionStroke?.finished ?? false;

  // ===================
  // Lasso menu methods:
  // ===================

  bool get showLassoMenu =>
      _easel.selectedTool is Lasso && finishedSelection && !isTransformMode;

  /// Erases original image and transforms a copy.
  void transformSelection() {
    if (!finishedSelection) return;
    _launchTransformMode();
    _eraseSelection();
    _easel.removeSelection();
    notifyListeners();
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

  /// Erases all paint within selection.
  void eraseSelection() {
    if (!finishedSelection) return;
    _eraseSelection();
    _easel.removeSelection();
    notifyListeners();
  }

  // ===============
  // Transform mode:
  // ===============

  bool get isTransformMode => _isTransformMode;
  bool _isTransformMode = false;

  Offset get transformBoxCenterOffset =>
      _transformBoxCenterOffset * _easel.scale;
  Offset _transformBoxCenterOffset; // frame point

  /// Box rotation value in radians.
  double get transformBoxRotation => _transformBoxRotation;
  double _transformBoxRotation;

  Size get transformBoxDisplaySize => transformBoxAbsoluteSize * _easel.scale;

  Size get transformBoxAbsoluteSize => Size(
        _transformBoxSize.width.abs(),
        _transformBoxSize.height.abs(),
      );

  Size _transformBoxSize;

  bool get isFlippedVertically => _transformBoxSize.height < 0;

  bool get isFlippedHorizontally => _transformBoxSize.width < 0;

  ui.Image get transformImage => _transformImage;
  ui.Image _transformImage;

  Matrix4 get imageTransform {
    var t = Matrix4Transform();
    final halfSize = transformBoxAbsoluteSize.center(Offset.zero);

    t = t.translateOffset(_transformBoxCenterOffset - halfSize);
    t = t.rotateByCenter(transformBoxRotation, transformBoxAbsoluteSize);

    if (isFlippedHorizontally) t = t.flipHorizontally(origin: halfSize);
    if (isFlippedVertically) t = t.flipVertically(origin: halfSize);

    t = t.scaleBy(
      x: transformBoxAbsoluteSize.width / transformImage.width,
      y: transformBoxAbsoluteSize.height / transformImage.height,
    );

    return t.matrix4;
  }

  void _launchTransformMode() {
    _isTransformMode = true;

    // Position box:
    _transformBoxCenterOffset = selectionStroke.boundingRect.center;
    _transformBoxSize = selectionStroke.boundingRect.size;
    _transformBoxRotation = 0;

    _setTransformImage();

    notifyListeners();
  }

  Future<void> _setTransformImage() async {
    _transformImage = await generateImage(
      MaskedImagePainter(
        original: _easel.frame.snapshot,
        mask: selectionStroke.path,
      ),
      _transformBoxSize.width.toInt(),
      _transformBoxSize.height.toInt(),
    );
    notifyListeners();
  }

  void endTransformMode() {
    _isTransformMode = false;

    _pasteTransformedImage();
    // TODO: Remove snapshot with erased selection

    // Remove box:
    _transformBoxCenterOffset = null;
    _transformBoxSize = null;
    _transformBoxRotation = null;

    _transformImage = null;
    notifyListeners();
  }

  Future<void> _pasteTransformedImage() async {
    final snapshot = await generateImage(
      TransformedImagePainter(
        transformedImage: transformImage,
        transform: imageTransform,
        background: _easel.frame.snapshot,
      ),
      _easel.frame.width.toInt(),
      _easel.frame.height.toInt(),
    );
    _easel.pushSnapshot(snapshot);
  }

  void onTransformBoxDrag(DragUpdateDetails details) {
    final d = details.delta;
    final cos = math.cos(_transformBoxRotation);
    final sin = math.sin(_transformBoxRotation);
    final rotatedDelta = Offset(
      d.dx * cos - d.dy * sin,
      d.dx * sin + d.dy * cos,
    );
    _transformBoxCenterOffset += rotatedDelta / _easel.scale;
    notifyListeners();
  }

  double _xDragDirection;
  double _yDragDirection;

  void onKnobStart(Alignment knobPosition) {
    _xDragDirection = _transformBoxSize.width.sign;
    _yDragDirection = _transformBoxSize.height.sign;
  }

  void onKnobDrag(Alignment knobPosition, DragUpdateDetails details) {
    final dx = knobPosition.x * details.delta.dx * 2 / _easel.scale;
    final dy = knobPosition.y * details.delta.dy * 2 / _easel.scale;

    _transformBoxSize = Size(
      _transformBoxSize.width + dx * _xDragDirection,
      _transformBoxSize.height + dy * _yDragDirection,
    );
    notifyListeners();
  }

  void onKnobEnd(Alignment knobPosition) {
    _xDragDirection = null;
    _yDragDirection = null;
  }

  void onRotationKnobDrag(DragUpdateDetails details) {
    final fingerEaselPoint = _toEaselPoint(details.globalPosition);
    final fingerFramePoint = _easel.toFramePoint(fingerEaselPoint);

    final tan = ui.Tangent(
      _transformBoxCenterOffset,
      fingerFramePoint - _transformBoxCenterOffset,
    );
    _transformBoxRotation = isFlippedVertically
        ? -tan.angle - math.pi / 2
        : -tan.angle + math.pi / 2;
    notifyListeners();
  }

  Offset _toEaselPoint(Offset globalPoint) {
    return globalPoint - Offset(0, _headerHeight);
  }

  // ==============
  // Paint methods:
  // ==============

  void _fillSelection() {
    final fillColor = (_easel.selectedTool as Lasso).color;
    selectionStroke.setColorPaint(fillColor);
    _applySelectionStrokeToFrame();
  }

  void _eraseSelection() {
    selectionStroke.setErasingPaint();
    _applySelectionStrokeToFrame();
  }

  Future<void> _applySelectionStrokeToFrame() async {
    final snapshot = await generateImage(
      FramePainter(frame: _easel.frame, strokes: [selectionStroke]),
      _easel.frame.width.toInt(),
      _easel.frame.height.toInt(),
    );
    _easel.pushSnapshot(snapshot);
  }
}
