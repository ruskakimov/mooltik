import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:path/path.dart' as p;

/// Holds project data, reads and writes to project folder.
///
/// Project file structure looks like the following:
///
/// ```
/// /project_[creation_timestamp]
///    project_data.json
///    frame[creation_timestamp].png
///    /sounds
///        [creation_timestamp].aac
/// ```
///
/// Where `[creation_timestamp]` is replaced with an epoch of creation time of that piece of data.
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

  /// Loads project files into memory.
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

  /// Frees the memory of project files.
  void close() {
    _frames = null;
    _soundClips = null;
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
          _getFrameFile(frame.id),
          frame.snapshot,
        ),
      ),
    );

    // Write thumbnail.
    if (frames.first.snapshot != null) {
      await pngWrite(thumbnail, frames.first.snapshot);
    }

    await _deleteUnusedFiles();

    // Refresh gallery thumbnails.
    notifyListeners();
  }

  /// Deletes frames and sound clips that were removed from the project.
  Future<void> _deleteUnusedFiles() async {
    await _deleteUnusedFrameImages();
  }

  Future<void> _deleteUnusedFrameImages() async {
    final Set<String> usedFrameImages =
        frames.map((frame) => _getFrameFilePath(frame.id));

    bool _isUnusedFrameImage(String path) =>
        p.extension(path) == '.png' && !usedFrameImages.contains(path);

    await for (final entity in directory.list()) {
      if (_isUnusedFrameImage(entity.path)) {
        // TODO: await all at once
        await entity.delete();
      }
    }
  }

  Future<FrameModel> _getFrame(FrameSaveData frameData, Size size) async {
    final file = _getFrameFile(frameData.id);
    final image = file.existsSync() ? await pngRead(file) : null;
    return FrameModel(
      id: frameData.id,
      duration: frameData.duration,
      size: size,
      initialSnapshot: image,
    );
  }

  File _getFrameFile(int id) => File(_getFrameFilePath(id));

  String _getFrameFilePath(int id) => p.join(directory.path, 'frame$id.png');

  File _getSoundClipFile(int id) => File(p.join(
        directory.path,
        'sounds',
        '$id.aac',
      ));

  Future<File> getNewSoundClipFile() async =>
      await _getSoundClipFile(DateTime.now().millisecondsSinceEpoch)
          .create(recursive: true);
}
