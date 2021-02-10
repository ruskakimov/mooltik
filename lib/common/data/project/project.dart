import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';
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
/// /project_[creation_epoch]
///    project_data.json
///    frame[creation_epoch].png
///    /sounds
///        [creation_epoch].aac
/// ```
///
/// Where `[creation_epoch]` is replaced with an epoch of creation time of that piece of data.
class Project extends ChangeNotifier {
  /// Loads project from the existing project directory.
  Project(this.directory)
      : creationEpoch = int.parse(p.basename(directory.path).split('_').last),
        thumbnail = File(p.join(directory.path, 'thumbnail.png')),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  /// Creates a new project from scratch in a given directory.
  factory Project.createIn(Directory parentDirectory) {
    final int id = DateTime.now().millisecondsSinceEpoch;
    final String folderName = 'project_$id';
    final Directory dir = Directory(p.join(parentDirectory.path, folderName))
      ..createSync();
    return Project(dir);
  }

  static bool validProjectDirectory(Directory directory) {
    final String folderName = p.basename(directory.path);
    return RegExp(r'^project_[0-9]+$').hasMatch(folderName);
  }

  final Directory directory;

  final int creationEpoch;

  final File thumbnail;

  final File _dataFile;

  List<FrameModel> get frames => _frames;
  List<FrameModel> _frames = [];

  List<SoundClip> get soundClips => _soundClips;
  List<SoundClip> _soundClips = [];

  Size get frameSize => _frameSize;
  Size _frameSize;

  bool _shouldClose;

  Timer _autoSaveTimer;

  /// Loads project files into memory.
  Future<void> open() async {
    // Check if already open.
    if (_frames.isNotEmpty) {
      // Prevent freeing memory after closing and quickly opening the project again.
      _shouldClose = false;
      return;
    }

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

    _startAutoSaveTimer();
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer = Timer.periodic(
      Duration(minutes: 1),
      (_) => save(),
    );
  }

  /// Frees the memory of project files and stops auto-save.
  void _close() {
    _frames.clear();
    _soundClips.clear();
    _autoSaveTimer?.cancel();
  }

  Future<void> saveAndClose() async {
    _shouldClose = true;
    await save();

    // User might have opened the project again while it was writing to disk.
    if (_shouldClose) {
      _close();
    }
  }

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
    await _deleteUnusedSoundFiles();
  }

  Future<void> _deleteUnusedFrameImages() async {
    final Set<String> usedFrameImages =
        frames.map((frame) => _getFrameFilePath(frame.id)).toSet();

    bool _isUnusedFrameImage(String path) =>
        p.extension(path) == '.png' &&
        p.basename(path) != 'thumbnail.png' &&
        !usedFrameImages.contains(path);

    await deleteFilesWhere(directory, _isUnusedFrameImage);
  }

  Future<void> _deleteUnusedSoundFiles() async {
    final soundDir = Directory(_getSoundDirectoryPath());
    if (!soundDir.existsSync()) return;

    final Set<String> usedSoundFiles =
        soundClips.map((clip) => clip.file.path).toSet();

    bool _isUnusedSoundFile(String path) =>
        p.extension(path) == '.aac' && !usedSoundFiles.contains(path);

    await deleteFilesWhere(soundDir, _isUnusedSoundFile);
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

  File _getSoundClipFile(int id) => File(_getSoundClipFilePath(id));

  String _getSoundDirectoryPath() => p.join(directory.path, 'sounds');

  String _getSoundClipFilePath(int id) =>
      p.join(_getSoundDirectoryPath(), '$id.aac');

  Future<File> getNewSoundClipFile() async =>
      await _getSoundClipFile(DateTime.now().millisecondsSinceEpoch)
          .create(recursive: true);
}
