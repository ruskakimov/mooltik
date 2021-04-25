import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:mooltik/drawing/ui/frame_painter.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:path/path.dart' as p;

const String _binnedPostfix = '_binned';

typedef CreateNewFrame = Future<FrameModel> Function();

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
  /// Loads project from an existing project directory.
  Project(this.directory)
      : creationEpoch =
            parseCreationEpochFromDirectoryName(p.basename(directory.path)),
        binned = parseBinnedFromDirectoryName(p.basename(directory.path)),
        thumbnail = File(p.join(directory.path, 'thumbnail.png')),
        _dataFile = File(p.join(directory.path, 'project_data.json'));

  /// Creates a new project from scratch in a given directory.
  factory Project.createIn(Directory parentDirectory) {
    final dirName = directoryName(DateTime.now().millisecondsSinceEpoch);
    final dir = Directory(p.join(parentDirectory.path, dirName))..createSync();
    return Project(dir);
  }

  static String directoryName(int creationEpoch, [bool binned = false]) {
    var dirName = 'project_$creationEpoch';
    if (binned) dirName += _binnedPostfix;
    return dirName;
  }

  static int parseCreationEpochFromDirectoryName(String dirName) {
    final match = RegExp(r'[0-9]+').stringMatch(dirName);
    return int.parse(match);
  }

  static bool parseBinnedFromDirectoryName(String dirName) {
    return RegExp('.*$_binnedPostfix').hasMatch(dirName);
  }

  static bool validProjectDirectory(Directory directory) {
    bool valid;
    try {
      final dirName = p.basename(directory.path);
      final creationEpoch = parseCreationEpochFromDirectoryName(dirName);
      final binned = parseBinnedFromDirectoryName(dirName);
      valid = dirName == directoryName(creationEpoch, binned);
    } catch (e) {
      valid = false;
    }
    return valid;
  }

  final Directory directory;

  final int creationEpoch;

  /// Whether this project currently resides in the bin.
  final bool binned;

  final File thumbnail;

  final File _dataFile;

  Sequence<SceneModel> get scenes => _scenes;
  Sequence<SceneModel> _scenes;

  // TODO: Check if lazy or not
  Iterable<FrameModel> get allFrames => _scenes.iterable
      .map((scene) => scene.frameSeq.iterable)
      .expand((iterable) => iterable);

  Iterable<FrameModel> get exportFrames => _scenes.iterable
      .map((scene) => scene.exportFrames)
      .expand((iterable) => iterable);

  List<SoundClip> get soundClips => _soundClips;
  List<SoundClip> _soundClips;

  Size get frameSize => _frameSize;
  Size _frameSize;

  bool _shouldClose;

  String _saveDataOnDisk;
  Timer _autosaveTimer;

  /// Loads project files into memory.
  Future<void> open() async {
    // Check if already open.
    if (_scenes != null) {
      // Prevent freeing memory after closing and quickly opening the project again.
      _shouldClose = false;
      return;
    }

    if (await _dataFile.exists()) {
      // Existing project.
      _saveDataOnDisk = await _dataFile.readAsString();
      final data = ProjectSaveData.fromJson(
        jsonDecode(_saveDataOnDisk),
        directory.path,
        _getSoundDirectoryPath(),
      );
      _frameSize = Size(data.width, data.height);
      _scenes = Sequence<SceneModel>(data.scenes);

      // TODO: Loading all frames into memory doesn't scale.
      await Future.wait(allFrames.map((frame) => frame.loadSnapshot()));

      _soundClips =
          data.sounds.where((sound) => sound.file.existsSync()).toList();
    } else {
      // New project.
      _frameSize = const Size(1280, 720);
      _scenes = Sequence<SceneModel>([await createNewScene()]);
      _soundClips = [];
    }

    _autosaveTimer = Timer.periodic(
      Duration(minutes: 1),
      (_) => _updateSaveDataOnDisk(),
    );
  }

  Future<void> saveAndClose() async {
    _shouldClose = true;
    _autosaveTimer?.cancel();
    await save();

    // User might have opened the project again while it was writing to disk.
    if (_shouldClose) {
      _freeMemory();
    }
  }

  void _freeMemory() {
    _scenes = null;
    _soundClips = null;
  }

  Future<void> save() async {
    await _updateSaveDataOnDisk();

    // Write thumbnail.
    final image = await generateImage(
      FramePainter(frame: allFrames.first),
      _frameSize.width.toInt(),
      _frameSize.height.toInt(),
    );
    await pngWrite(thumbnail, image);

    await _deleteUnusedFiles();

    // Refresh gallery thumbnails.
    notifyListeners();
  }

  Future<void> _updateSaveDataOnDisk() async {
    final saveData = _generateSaveData();

    if (saveData != _saveDataOnDisk) {
      await _dataFile.writeAsString(saveData);
      _saveDataOnDisk = saveData;
    }
  }

  String _generateSaveData() {
    final data = ProjectSaveData(
      width: _frameSize.width,
      height: _frameSize.height,
      scenes: _scenes.iterable.toList(),
      sounds: _soundClips,
    );
    return jsonEncode(data);
  }

  /// Deletes frames and sound clips that were removed from the project.
  Future<void> _deleteUnusedFiles() async {
    await _deleteUnusedFrameImages();
    await _deleteUnusedSoundFiles();
  }

  Future<void> _deleteUnusedFrameImages() async {
    final Set<String> usedFrameImages =
        allFrames.map((frame) => frame.file.path).toSet();

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

  Future<FrameModel> createNewFrame() async {
    final image = await generateImage(
      null,
      _frameSize.width.toInt(),
      _frameSize.height.toInt(),
    );
    final file = _getFrameFile(DateTime.now().millisecondsSinceEpoch);
    await pngWrite(file, image);
    return FrameModel(file: file, snapshot: image);
  }

  Future<SceneModel> createNewScene() async {
    return SceneModel(
      frameSeq: Sequence<FrameModel>([await createNewFrame()]),
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

  Future<void> loadSoundClipFromFile(File source) async {
    if (_soundClips.isNotEmpty) {
      _soundClips.clear();
    }

    final sourceExtension = p.extension(source.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$sourceExtension';

    final soundFile = File(p.join(_getSoundDirectoryPath(), fileName));
    await soundFile.create(recursive: true);
    await source.copy(soundFile.path);

    final soundClip = SoundClip(
      file: soundFile,
      startTime: Duration.zero,
      duration: await getSoundFileDuration(soundFile),
    );

    _soundClips.add(soundClip);

    notifyListeners();
  }
}
