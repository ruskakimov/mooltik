import 'dart:ui';
import 'dart:io';

import 'package:mooltik/common/data/project/base_image.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/io/make_duplicate_path.dart';
import 'package:mooltik/common/data/io/png.dart';

/// Manages a single image file.
/// Notifies listeners when image changes.
class DiskImage extends BaseImage {
  DiskImage({
    required this.file,
    required this.width,
    required this.height,
    Image? snapshot,
  })  : assert(snapshot == null ||
            snapshot.width == width && snapshot.height == height),
        _snapshot = snapshot?.clone() {
    file.createSync();
  }

  DiskImage.loaded({
    required this.file,
    required Image snapshot,
  })  : width = snapshot.width,
        height = snapshot.height,
        _snapshot = snapshot.clone() {
    file.createSync();
  }

  final File file;

  final int width;
  final int height;

  Image? get snapshot => _snapshot;
  Image? _snapshot;

  bool get loaded => _snapshot != null;

  Future<bool> get isFileEmpty async =>
      !file.existsSync() || (await file.length()) == 0;

  Future<void> loadSnapshot() async {
    if (await isFileEmpty) {
      await _loadEmptySnapshot();
    } else {
      await _loadFromFile();
    }
  }

  Future<void> _loadEmptySnapshot() async {
    _snapshot?.dispose();
    _snapshot = await generateEmptyImage(width, height);
    notifyListeners();
  }

  Future<void> _loadFromFile() async {
    _snapshot?.dispose();
    _snapshot = await pngRead(file);
    notifyListeners();
  }

  void changeSnapshot(Image? newSnapshot) {
    _snapshot?.dispose();
    _snapshot = newSnapshot?.clone();
    notifyListeners();
  }

  Future<void> saveSnapshot() async {
    if (_snapshot == null) {
      if (await isFileEmpty) {
        await _loadEmptySnapshot();
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

  @override
  List<Object?> get props => [file.path];

  @override
  void dispose() {
    _snapshot?.dispose();
    super.dispose();
  }

  @override
  void draw(Canvas canvas, Offset offset, Paint paint) {
    final image = _snapshot;
    if (image != null) canvas.drawImage(image, offset, paint);
  }
}
