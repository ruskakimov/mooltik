import 'dart:ui';

import 'package:flutter/foundation.dart';

/// A stack of image progression with maximum length.
class ImageHistoryStack {
  ImageHistoryStack({
    @required this.maxCount,
  });

  /// Maximum number of images in the stack.
  final int maxCount;

  /// Push a new [snapshot] on top of the stack.
  void push(Image snapshot) {}
}
