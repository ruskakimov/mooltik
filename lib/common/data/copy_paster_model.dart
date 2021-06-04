import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/generate_image.dart';

class CopyPasterModel extends ChangeNotifier {
  ui.Image? get copiedImage => _copiedImage;
  ui.Image? _copiedImage;

  void copyImage(ui.Image? image) {
    _copiedImage = image;
    notifyListeners();
  }

  bool get canPaste => _copiedImage != null;

  Future<ui.Image> pasteOn(ui.Image destination) async {
    return generateImage(
      PastePainter(source: _copiedImage!, destination: destination),
      destination.width,
      destination.height,
    );
  }
}

class PastePainter extends CustomPainter {
  PastePainter({
    required this.source,
    required this.destination,
  });

  final ui.Image source;
  final ui.Image destination;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(destination, Offset.zero, Paint());
    canvas.drawImage(source, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(PastePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PastePainter oldDelegate) => false;
}
