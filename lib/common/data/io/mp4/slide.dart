import 'dart:io';

/// Data class for video export.
class Slide {
  Slide(this.pngImage, this.duration);

  /// Slide image in PNG format.
  final File pngImage;

  /// Slide duration.
  final Duration duration;
}
