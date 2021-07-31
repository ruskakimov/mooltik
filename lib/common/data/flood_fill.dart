import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:mooltik/common/data/extensions/color_methods.dart';
import 'package:mooltik/common/data/io/image.dart';
import 'package:mooltik/ffi_bridge.dart';

/// Flood fills [image] with the given [color] starting at [startX], [startY].
Future<ui.Image?> floodFill(
  ui.Image source,
  int startX,
  int startY,
  ui.Color color,
) async {
  final imageByteData = await source.toByteData();

  final s = Stopwatch()..start();
  final resultByteData = await compute(
    _fillIsolate,
    _FillIsolateParams(
      imageByteData: imageByteData!,
      width: source.width,
      height: source.height,
      startX: startX,
      startY: startY,
      fillColor: color,
    ),
  );
  s.stop();
  print('${s.elapsedMilliseconds},');

  if (resultByteData != null)
    return imageFromBytes(resultByteData, source.width, source.height);
  else
    return null;
}

class _FillIsolateParams {
  final ByteData imageByteData;
  final int width;
  final int height;
  final int startX;
  final int startY;
  final ui.Color fillColor;

  _FillIsolateParams({
    required this.imageByteData,
    required this.width,
    required this.height,
    required this.startX,
    required this.startY,
    required this.fillColor,
  });
}

ByteData? _fillIsolate(_FillIsolateParams params) {
  final exitCode = FFIBridge().floodFill(
    params.imageByteData.buffer.asUint32List(),
    params.width,
    params.height,
    params.startX,
    params.startY,
    params.fillColor.toABGR(),
  );
  if (exitCode == 0)
    return params.imageByteData;
  else
    return null;
}
