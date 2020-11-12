import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:mooltik/home/project_save_data.dart';
import 'package:path/path.dart' as p;

class Project {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  final Directory directory;

  final int id;

  final File _dataFile;

  ReelModel get reel => _reel;
  ReelModel _reel;

  Future<void> open() async {
    if (await _dataFile.exists()) {
      // Existing project.
      final String contents = await _dataFile.readAsString();
      final ProjectSaveData data =
          ProjectSaveData.fromJson(jsonDecode(contents));
      // TODO: Read images and init ReelModel.
    } else {
      // New project.
      _reel = ReelModel();
    }
  }

  Future<void> save() async {
    final List<FrameModel> frames = _reel.frames;

    // Write project data.
    final ProjectSaveData data = ProjectSaveData(
      width: _reel.frameSize.width,
      height: _reel.frameSize.height,
      drawings: frames
          .map((f) => DrawingSaveData(id: f.id, duration: f.duration))
          .toList(),
    );
    await _dataFile.writeAsString(jsonEncode(data));

    // Write images.
    for (final FrameModel frame in frames) {
      final img = await imageFromFrame(frame);
      final pngBytes = encodePng(img, level: 0);
      final file = File(p.join(directory.path, 'drawing${frame.id}.png'));
      await file.writeAsBytes(pngBytes);
    }
  }

  void close() {
    _reel = null;
  }
}
