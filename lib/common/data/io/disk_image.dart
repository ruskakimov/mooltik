import 'dart:ui';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mooltik/common/data/project/image_interface.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';
import 'package:mooltik/common/data/io/png.dart';

/// Manages a single image file.
class DiskImage with EquatableMixin implements ImageInterface {
  DiskImage({
    required this.file,
    required this.width,
    required this.height,
    Image? snapshot,
  })  : assert(snapshot == null ||
            snapshot.width == width && snapshot.height == height),
        _snapshot = snapshot {
    file.createSync();
  }

  DiskImage.loaded({
    required this.file,
    required Image snapshot,
  })  : width = snapshot.width,
        height = snapshot.height,
        _snapshot = snapshot {
    file.createSync();
  }

  final File file;

  final int width;
  final int height;

  Image? get snapshot => _snapshot;
  Image? _snapshot;

  Size get size => Size(width.toDouble(), height.toDouble());

  bool get loaded => _snapshot != null;

  Future<bool> get isFileEmpty async =>
      !file.existsSync() || (await file.length()) == 0;

  Future<void> loadSnapshot() async {
    if (await isFileEmpty) {
      await _loadEmptySnapshot();
    } else {
      _snapshot = await pngRead(file);
    }
  }

  Future<void> _loadEmptySnapshot() async {
    _snapshot?.dispose();
    _snapshot = await generateEmptyImage(width, height);
  }

  Future<void> saveSnapshot() async {
    if (_snapshot == null) {
      if (await isFileEmpty) {
        _loadEmptySnapshot();
      } else {
        throw Exception('Cannot save empty snapshot if file is not empty.');
      }
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

  /// Creates an empty image with the same dimensions.
  Future<DiskImage> cloneEmpty() async {
    final freePath = makeFreeDuplicatePath(file.path);
    final image = DiskImage(
      file: File(freePath),
      width: width,
      height: height,
    );

    await image.loadSnapshot();
    return image;
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

  @override
  void draw(Canvas canvas, Offset offset, Paint paint) {
    final image = _snapshot;
    if (image != null) canvas.drawImage(image, offset, paint);
  }
}
