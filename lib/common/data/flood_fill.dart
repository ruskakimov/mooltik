import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

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

  // Can be refactored with `compute` after this PR (https://github.com/flutter/flutter/pull/86591) lands in stable.
  final receivePort = ReceivePort();

  final isolate = await Isolate.spawn(
    _fillIsolate,
    _FillIsolateParams(
      imageByteData: imageByteData!,
      width: source.width,
      height: source.height,
      startX: startX,
      startY: startY,
      fillColor: color,
      sendPort: receivePort.sendPort,
    ),
  );

  final resultByteData = await receivePort.first as ByteData?;

  receivePort.close();
  isolate.kill();

  if (resultByteData == null) return null;

  return imageFromRawBytes(resultByteData, source.width, source.height);
}

class _FillIsolateParams {
  final ByteData imageByteData;
  final int width;
  final int height;
  final int startX;
  final int startY;
  final ui.Color fillColor;
  final SendPort sendPort;

  _FillIsolateParams({
    required this.imageByteData,
    required this.width,
    required this.height,
    required this.startX,
    required this.startY,
    required this.fillColor,
    required this.sendPort,
  });
}

void _fillIsolate(_FillIsolateParams params) {
  final exitCode = FFIBridge().floodFill(
    params.imageByteData.buffer.asUint32List(),
    params.width,
    params.height,
    params.startX,
    params.startY,
    params.fillColor.toABGR(),
  );

  final result = exitCode == 0 ? params.imageByteData : null;

  params.sendPort.send(result);
}
