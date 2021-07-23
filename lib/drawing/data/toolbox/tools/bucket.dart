import 'dart:ui' as ui;
import 'package:image/image.dart' as duncan;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/data/flood_fill.dart';
import 'package:mooltik/common/data/io/image.dart';
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
  void onStrokeStart(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  void onStrokeUpdate(Offset canvasPoint) {
    _lastPoint = canvasPoint;
  }

  @override
  Future<ui.Image?> onStrokeEnd(Rect canvasArea, ui.Image canvasImage) async {
    return applyBucketAt(
      canvasImage,
      _lastPoint.dx.toInt(),
      _lastPoint.dy.toInt(),
    );
  }

  @override
  void onStrokeCancel() {}

  /// Returns [source] image with fill starting at [startX] and [startY].
  Future<ui.Image> applyBucketAt(
    ui.Image source,
    int startX,
    int startY,
  ) async {
    final imageByteData = await source.toByteData();

    // final resultByteData = floodFill(
    //   imageByteData!,
    //   source.width,
    //   source.height,
    //   startX,
    //   startY,
    //   color.value,
    // );

    final duncanSource = await _toDuncanImage(source);

    final duncanResult = duncan.fillFlood(
      duncanSource,
      startX,
      startY,
      _toDuncanColor(color),
    );

    return _toUiImage(duncanResult);

    // return imageFromBytes(resultByteData, source.width, source.height);
  }

  Future<duncan.Image> _toDuncanImage(ui.Image image) async {
    final imageByteData = await image.toByteData();
    return duncan.Image.fromBytes(
      image.width,
      image.height,
      imageByteData!.buffer.asUint8List(),
    );
  }

  Future<ui.Image> _toUiImage(duncan.Image image) {
    final imageByteData = image.getBytes();
    return imageFromBytes(
      imageByteData.buffer.asByteData(),
      image.width,
      image.height,
    );
  }

  int _toDuncanColor(ui.Color color) {
    final bytes = [
      color.alpha,
      color.blue,
      color.green,
      color.red,
    ];
    return bytes.reduce((a, b) => (a << 8) | b);
  }
}
