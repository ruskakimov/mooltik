import 'dart:ui' as ui;

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

  @override
  void onStrokeStart(Offset canvasPoint) {}

  @override
  void onStrokeUpdate(Offset canvasPoint) {}

  @override
  Future<ui.Image?> onStrokeEnd(Rect canvasArea, ui.Image canvasImage) async {
    return applyBucketAt(canvasImage, 0, 0);
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

    final resultByteData = floodFill(
      imageByteData!,
      source.width,
      source.height,
      startX,
      startY,
      color.value,
    );

    return imageFromBytes(resultByteData, source.width, source.height);
  }
}
