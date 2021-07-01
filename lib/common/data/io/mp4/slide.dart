import 'dart:io';

import 'package:mooltik/common/data/duration_methods.dart';

/// Data class for video export.
class Slide {
  Slide(this.pngImage, this.duration);

  /// Slide image in PNG format.
  final File pngImage;

  /// Slide duration.
  final Duration duration;

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
        File(json[_filePathKey]),
        (json[_durationKey] as String).parseDuration(),
      );

  Map<String, dynamic> toJson() => {
        _filePathKey: pngImage.path,
        _durationKey: duration.toString(),
      };

  static const String _filePathKey = 'path';
  static const String _durationKey = 'duration';
}
