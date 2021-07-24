import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as duncan;

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

  Future<ui.Image?> rasterizeStroke(
    Rect canvasArea,
    ui.Image canvasImage,
  ) async {
    return applyBucketAt(
      canvasImage,
      _lastPoint.dx.toInt(),
      _lastPoint.dy.toInt(),
    );
  }

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

    var receivePort = ReceivePort();

    await Isolate.spawn(
      decodeIsolate,
      IsolateParam(
        imageByteData: imageByteData!.buffer.asUint8List(),
        width: source.width,
        height: source.height,
        fillColor: _toDuncanColor(color),
        startX: startX,
        startY: startY,
        sendPort: receivePort.sendPort,
      ),
    );

    // Get the processed image from the isolate.
    var duncanResult = await receivePort.first as duncan.Image;

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

class IsolateParam {
  final int width;
  final int height;
  final int startX;
  final int startY;
  final int fillColor;
  final Uint8List imageByteData;
  final SendPort sendPort;

  IsolateParam({
    required this.width,
    required this.height,
    required this.startX,
    required this.startY,
    required this.fillColor,
    required this.imageByteData,
    required this.sendPort,
  });
}

void decodeIsolate(IsolateParam param) {
  final duncanSource = duncan.Image.fromBytes(
    param.width,
    param.height,
    param.imageByteData.buffer.asUint8List(),
  );

  final duncanResult = duncan.fillFlood(
    duncanSource,
    param.startX,
    param.startY,
    param.fillColor,
  );

  param.sendPort.send(duncanResult);
}
