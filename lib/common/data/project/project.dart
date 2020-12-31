import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:path/path.dart' as p;

class Project extends ChangeNotifier {
  Project(this.directory)
      : id = int.parse(p.basename(directory.path).split('_').last),
        thumbnail = File(p.join(directory.path, 'thumbnail.png')),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  final Directory directory;

  final int id;

  final File thumbnail;

  final File _dataFile;

  List<FrameModel> get frames => _frames;
  List<FrameModel> _frames = [];

  List<SoundClip> get soundClips => _soundClips;
  List<SoundClip> _soundClips = [];

  Size get frameSize => _frameSize;
  Size _frameSize;

  Future<void> open() async {
    if (await _dataFile.exists()) {
      // Existing project.
      final contents = await _dataFile.readAsString();
      final data = ProjectSaveData.fromJson(jsonDecode(contents));
      _frameSize = Size(data.width, data.height);
      _frames = await Future.wait(
        data.frames.map((frameData) => _getFrame(frameData, frameSize)),
      );
      _soundClips = data.sounds;
    } else {
      // New project.
      _frameSize = const Size(1280, 720);
      _frames = [FrameModel(size: frameSize)];
    }
  }

  Future<FrameModel> _getFrame(FrameSaveData frameData, Size size) async {
    final file = getFrameFile(frameData.id);
    final image = file.existsSync() ? await pngRead(file) : null;
    return FrameModel(
      id: frameData.id,
      duration: frameData.duration,
      size: size,
      initialSnapshot: image,
    );
  }

  // TODO: Remove deleted files
  Future<void> save() async {
    // Write project data.
    final data = ProjectSaveData(
      width: _frameSize.width,
      height: _frameSize.height,
      frames: _frames
          .map((f) => FrameSaveData(id: f.id, duration: f.duration))
          .toList(),
      sounds: _soundClips,
    );
    await _dataFile.writeAsString(jsonEncode(data));

    // Write images.
    await Future.wait(
      frames.where((frame) {
        return frame.snapshot != null;
      }).map(
        (frame) => pngWrite(
          getFrameFile(frame.id),
          frame.snapshot,
        ),
      ),
    );

    // Write thumbnail.
    if (frames.first.snapshot != null) {
      await pngWrite(thumbnail, frames.first.snapshot);
    }

    // Refresh gallery thumbnails.
    notifyListeners();
  }

  void close() {
    _frames = null;
  }

  File getFrameFile(int id) => File(p.join(directory.path, 'frame$id.png'));

  File getSoundClipFile(int id) => File(p.join(
        directory.path,
        'sounds',
        '$id.aac',
      ));

  Future<File> getNewSoundClipFile() async =>
      await getSoundClipFile(DateTime.now().millisecondsSinceEpoch)
          .create(recursive: true);
}
