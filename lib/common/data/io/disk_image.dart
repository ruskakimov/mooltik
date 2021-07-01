import 'dart:ui';
import 'dart:io';

import 'package:mooltik/common/data/io/png.dart';

/// Manages a single image file.
class DiskImage {
  DiskImage({
    required this.file,
    Image? snapshot,
  }) : _snapshot = snapshot;

  final File file;

  Image? get snapshot => _snapshot;
  Image? _snapshot;

  Size get size => Size(width!.toDouble(), height!.toDouble());

  int? get width => _snapshot?.width;

  int? get height => _snapshot?.height;

  void changeSnapshot(Image? newSnapshot) {
    _snapshot = newSnapshot;
  }

  Future<void> loadSnapshot() async {
    _snapshot = await pngRead(file);
  }

  Future<void> saveSnapshot() async {
    if (_snapshot == null) throw Exception('Snapshot is missing.');
    await pngWrite(file, _snapshot!);
  }

  factory DiskImage.fromJson(Map<String, dynamic> json) => DiskImage(
        file: File(json[_filePathKey]),
      );

  Map<String, dynamic> toJson() => {
        _filePathKey: file.path,
      };

  static const String _filePathKey = 'path';
}
