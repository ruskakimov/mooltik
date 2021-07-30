import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/image.dart';
import 'package:mooltik/drawing/data/frame/stroke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool.dart';

class Bucket extends ToolWithColor {
  Bucket(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  IconData get icon => MdiIcons.formatColorFill;

  @override
  String get name => 'bucket';

  Offset _lastPoint = Offset.zero;

  @override
  Stroke? onStrokeStart(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  Stroke? onStrokeEnd() {}

  @override
  Stroke? onStrokeCancel() {}

  @override
  PaintOn? makePaintOn(ui.Rect canvasArea) {
    final frozenColor = color;
    final frozenX = _lastPoint.dx.toInt();
    final frozenY = _lastPoint.dy.toInt();

    return (ui.Image canvasImage) {
      return _applyBucketAt(
        canvasImage,
        frozenX,
        frozenY,
        frozenColor,
      );
    };
  }
}

/// Returns [source] image with fill starting at [startX] and [startY].
Future<ui.Image> _applyBucketAt(
  ui.Image source,
  int startX,
  int startY,
  Color color,
) async {
  final imageByteData = await source.toByteData();

  final s = Stopwatch()..start();
  final resultByteData = await compute(
    _fillProcess,
    _FillProcessParams(
      imageByteData: imageByteData!.buffer.asUint8List(),
      width: source.width,
      height: source.height,
      startX: startX,
      startY: startY,
      fillColor: color,
    ),
  );
  s.stop();
  print('${s.elapsedMilliseconds},');

  return imageFromBytes(resultByteData, source.width, source.height);
}

class _FillProcessParams {
  final Uint8List imageByteData;
  final int width;
  final int height;
  final int startX;
  final int startY;
  final Color fillColor;

  _FillProcessParams({
    required this.imageByteData,
    required this.width,
    required this.height,
    required this.startX,
    required this.startY,
    required this.fillColor,
  });
}

ByteData _fillProcess(_FillProcessParams params) {
  return floodFill(
    params.imageByteData.buffer.asByteData(),
    params.width,
    params.height,
    params.startX,
    params.startY,
    params.fillColor,
  );
}
