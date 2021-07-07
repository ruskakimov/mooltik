import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/iterable_methods.dart';
import 'package:path/path.dart' as p;
import 'package:mooltik/common/data/project/composite_frame.dart';

/// Makes an archive from images with the following structure.
///
/// [archiveName].zip
///   /scene_1
///     scene_1_1.png
///     scene_1_2.png
///   /scene_2
///     scene_2_1.png
///     scene_2_2.png
///     scene_2_3.png
Future<File?> generateImagesArchive({
  required String archiveName,
  required List<List<CompositeFrame>> framesSceneByScene,
  required Directory tempDir,
}) async {
  final imagesDir = Directory(p.join(tempDir.path, archiveName))..createSync();

  await Future.wait(
    framesSceneByScene.mapIndexed((sceneFrames, sceneIndex) async {
      final sceneNumber = sceneIndex + 1;
      final sceneDir = Directory(p.join(imagesDir.path, 'scene_$sceneNumber'))
        ..createSync();

      await Future.wait(sceneFrames.mapIndexed((frame, frameIndex) async {
        final frameNumber = frameIndex + 1;
        final file =
            _tempFile('scene_${sceneNumber}_$frameNumber.png', sceneDir);
        await pngWrite(file, await frame.toImage());
      }));
    }),
  );

  ZipFileEncoder().zipDirectory(imagesDir);

  return File('${imagesDir.path}.zip');
}

File _tempFile(String fileName, Directory directory) =>
    File(p.join(directory.path, fileName));
