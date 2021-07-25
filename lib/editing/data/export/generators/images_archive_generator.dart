import 'dart:io';

import 'package:mooltik/common/data/io/mp4/mp4.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/extensions/iterable_methods.dart';
import 'package:mooltik/editing/data/export/generators/generator.dart';

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
class ImagesArchiveGenerator extends Generator {
  ImagesArchiveGenerator({
    required this.archiveName,
    required this.framesSceneByScene,
    required this.progressCallback,
    required this.temporaryDirectory,
  })  : _totalImages = framesSceneByScene.expand((x) => x).toList().length,
        super(temporaryDirectory);

  final String archiveName;
  final List<List<CompositeFrame>> framesSceneByScene;
  final Directory temporaryDirectory;
  final ProgressCallback progressCallback;

  int _generatedImages = 0;
  final int _totalImages;

  @override
  Future<File?> generate() async {
    _generatedImages = 0;

    final imagesDir = Directory(p.join(temporaryDirectory.path, archiveName))
      ..createSync();

    try {
      await Future.wait(
        framesSceneByScene.mapIndexed((sceneFrames, sceneIndex) async {
          final sceneNumber = sceneIndex + 1;
          final sceneDir =
              Directory(p.join(imagesDir.path, 'scene_$sceneNumber'))
                ..createSync();

          for (var i = 0; i < sceneFrames.length; i++) {
            final file = makeTemporaryFile(
              'scene_${sceneNumber}_${i + 1}.png',
              sceneDir,
            );

            if (isCancelled) throw Exception('Cancelled.');
            print('Schedule writing PNG to ${file.path}');
            await pngWrite(file, await sceneFrames[i].toImage());
            print('Finished writing PNG to ${file.path}');

            _generatedImages++;
            progressCallback(_calcProgress());
          }
        }),
        eagerError: true,
      );
    } catch (e) {
      return null;
    }

    if (isCancelled) return null;
    ZipFileEncoder().zipDirectory(imagesDir);

    return isCancelled ? null : File('${imagesDir.path}.zip');
  }

  double _calcProgress() {
    return _generatedImages / _totalImages;
  }
}
