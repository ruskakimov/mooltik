import 'dart:ui';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';
import 'package:mooltik/common/data/io/png.dart';

/// Manages a single image file.
class DiskImage with EquatableMixin {
  DiskImage({
    required this.file,
    required this.width,
    required this.height,
    Image? snapshot,
  })  : assert(snapshot == null ||
            snapshot.width == width && snapshot.height == height),
        _snapshot = snapshot;

  DiskImage.loaded({
    required this.file,
    required Image snapshot,
  })  : width = snapshot.width,
        height = snapshot.height,
        _snapshot = snapshot;

  final File file;

  final int width;
  final int height;

  Image? get snapshot => _snapshot;
  Image? _snapshot;

  Size get size => Size(width.toDouble(), height.toDouble());

  bool get loaded => _snapshot != null;

  Future<void> loadSnapshot() async {
    if (file.existsSync()) {
      _snapshot = await pngRead(file);
    } else {
      await _loadEmptySnapshot();
    }
  }

  Future<void> _loadEmptySnapshot() async {
    _snapshot = await generateEmptyImage(width, height);
  }

  Future<void> saveSnapshot() async {
    final fileExists = file.existsSync();

    if (_snapshot == null && fileExists) {
      throw Exception('Snapshot is not loaded.');
    }

    if (_snapshot == null && !fileExists) {
      _loadEmptySnapshot();
    }

    await pngWrite(file, _snapshot!);
  }

  Future<DiskImage> duplicate() async {
    final duplicatePath = makeFreeDuplicatePath(file.path);
    final duplicateFile = await file.copy(duplicatePath);

    return DiskImage(
      file: duplicateFile,
      width: width,
      height: height,
      snapshot: snapshot?.clone(),
    );
  }

  DiskImage copyWith({Image? snapshot}) => DiskImage(
        file: file,
        width: width,
        height: height,
        snapshot: snapshot ?? this.snapshot,
      );

  @override
  List<Object?> get props => [file.path];

  void dispose() {
    _snapshot?.dispose();
  }
}
