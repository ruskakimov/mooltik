import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CopyPasterModel extends ChangeNotifier {
  ui.Image get copiedImage => _copiedImage;
  ui.Image _copiedImage;

  void copyImage(ui.Image image) {
    _copiedImage = image;
    notifyListeners();
  }

  bool get canPaste => _copiedImage != null;

  ui.Image pasteOn(ui.Image destination) {
    // TODO: Implement paste.
  }
}
