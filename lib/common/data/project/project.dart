import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/io/aac_to_m4a.dart';
import 'package:mooltik/common/data/io/delete_files_where.dart';
import 'package:mooltik/common/data/io/disk_image.dart';
import 'package:mooltik/common/data/io/generate_image.dart';
import 'package:mooltik/common/data/project/composite_frame.dart';
import 'package:mooltik/common/data/project/composite_image.dart';
import 'package:mooltik/common/data/project/sava_data_transcoder.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/ui/composite_image_painter.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/io/png.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:mooltik/editing/data/player_model.dart';
import 'package:path/path.dart' as p;

const String _binnedPostfix = '_binned';

typedef CreateNewFrame = Future<Frame> Function();

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
    final match = RegExp(r'[0-9]+').stringMatch(dirName)!;
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

  Sequence<Scene>? get scenes => _scenes;
  Sequence<Scene>? _scenes;

  Iterable<Frame> get allFrames => _scenes!.iterable
      .map((scene) => scene.allFrames)
      .expand((iterable) => iterable);

  /// Export frames for video.
  Iterable<CompositeFrame> get videoExportFrames => _scenes!.iterable
      .map((scene) => scene.getExportFrames())
      .expand((iterable) => iterable);

  /// Export frames for images archive. Frames are listed scene-by-scene.
  List<List<CompositeFrame>> get imagesExportFrames =>
      _scenes!.iterable.map((scene) {
        final seenFrames = Set<CompositeImage>();
        return scene.getExportFrames().where((frame) {
          final notDuplicate = seenFrames.add(frame.compositeImage);
          return notDuplicate;
        }).toList();
      }).toList();

  List<SoundClip> get soundClips => _soundClips;
  List<SoundClip> _soundClips = [];

  Size get frameSize => _frameSize;
  late Size _frameSize;

  late bool _shouldFreeMemory;

  String? _saveDataOnDisk;
  Timer? _autosaveTimer;

  bool get isOpen => _scenes != null;

  /// Loads project files into memory.
  Future<void> open() async {
    if (isOpen) {
      // Prevent freeing memory after closing and quickly opening the project again.
      _shouldFreeMemory = false;
      return;
    }

    if (await _dataFile.exists()) {
      await _openProjectFromDisk();
    } else {
      await _openNewProject();
    }

    _autosaveTimer = Timer.periodic(
      Duration(minutes: 1),
      (_) => updateSaveDataOnDisk(),
    );
  }

  Future<void> _openProjectFromDisk() async {
    _saveDataOnDisk = await _dataFile.readAsString();
    final json = jsonDecode(_saveDataOnDisk!);
    final transcodedJson = SaveDataTranscoder().transcodeToLatest(json);

    final data = ProjectSaveData.fromJson(
      transcodedJson,
      directory.path,
      _getSoundDirectoryPath(),
    );
    _frameSize = Size(data.width, data.height);
    _scenes = Sequence<Scene>(data.scenes);

    // TODO: Loading all frames into memory doesn't scale.
    await Future.wait(allFrames.map((frame) => frame.image.loadSnapshot()));

    _soundClips =
        data.sounds.where((sound) => sound.file.existsSync()).toList();
  }

  Future<void> _openNewProject() async {
    _frameSize = const Size(1280, 720);
    _scenes = Sequence<Scene>([await createNewScene()]);
    _soundClips = [];
  }

  Future<void> saveAndClose() async {
    _shouldFreeMemory = true;
    _autosaveTimer?.cancel();
    await save();

    // User might have opened the project again while it was writing to disk.
    if (_shouldFreeMemory) {
      _freeMemory();
    }
  }

  void _freeMemory() {
    _scenes = null;
    _soundClips = [];
  }

  Future<void> save() async {
    await updateSaveDataOnDisk();

    // Write thumbnail.
    final image = await generateImage(
      CompositeImagePainter(videoExportFrames.first.compositeImage),
      _frameSize.width.toInt(),
      _frameSize.height.toInt(),
    );
    await pngWrite(thumbnail, image);

    await _deleteUnusedFiles();

    // Refresh gallery thumbnails.
    notifyListeners();
  }

  Future<void> updateSaveDataOnDisk() async {
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
      scenes: _scenes!.iterable.toList(),
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
        allFrames.map((frame) => frame.image.file.path).toSet();

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

  Future<Frame> createNewFrame() async {
    final image = await generateImage(
      null,
      _frameSize.width.toInt(),
      _frameSize.height.toInt(),
    );
    final file = _getFrameFile(DateTime.now().millisecondsSinceEpoch);
    await pngWrite(file, image);
    return Frame(
      image: DiskImage(file: file, snapshot: image),
    );
  }

  Future<Scene> createNewScene() async {
    return Scene(layers: [
      await createNewSceneLayer(),
    ]);
  }

  Future<SceneLayer> createNewSceneLayer() async {
    final frameSeq = Sequence<Frame>([
      await createNewFrame(),
    ]);
    return SceneLayer(frameSeq);
  }

  File _getFrameFile(int id) => File(_getFrameFilePath(id));

  String _getFrameFilePath(int id) => p.join(directory.path, 'frame$id.png');

  String _getSoundDirectoryPath() => p.join(directory.path, 'sounds');

  Future<void> loadSoundClipFromFile(File source) async {
    if (_soundClips.isNotEmpty) {
      _soundClips.clear();
    }

    final soundFile = await _addSoundFileToProjectDir(source);

    final duration = await getSoundFileDuration(soundFile);
    if (duration == null) {
      throw Exception('Could not read duration from file ${soundFile.path}.');
    }

    final soundClip = SoundClip(
      file: soundFile,
      startTime: Duration.zero,
      duration: duration,
    );

    _soundClips.add(soundClip);

    notifyListeners();
  }

  Future<File> _addSoundFileToProjectDir(File source) async {
    final sourceExtension = p.extension(source.path);
    final copiedFile = File(p.join(
      _getSoundDirectoryPath(),
      '${DateTime.now().millisecondsSinceEpoch}$sourceExtension',
    ));
    await copiedFile.create(recursive: true);
    await source.copy(copiedFile.path);

    var output = copiedFile;

    // Raw AAC cannot be seeked, source: https://github.com/ryanheise/just_audio/issues/333#issuecomment-792867877
    if (sourceExtension == '.aac') {
      output = File(p.join(
        _getSoundDirectoryPath(),
        '${DateTime.now().millisecondsSinceEpoch}.m4a',
      ));
      await aacToM4a(copiedFile, output);
      await copiedFile.delete();
    }

    return output;
  }

  // =========
  // Metadata:
  // =========

  /// Number of files in project folder.
  String get fileCountLabel {
    final count = _fileCount;
    if (count == null) return '-';
    if (count == 1) return '1 file';
    return '$count files';
  }

  /// Total size of project folder.
  String get projectSizeLabel {
    final size = _sizeInBytes;
    if (size == null) return '-';

    if (size < 1000000) {
      final kb = size / 1000;
      return '${kb.toStringAsFixed(1)} KB';
    }

    final mb = size / 1000000;
    return '${mb.toStringAsFixed(1)} MB';
  }

  int? _fileCount;
  int? _sizeInBytes;

  Future<void> readMetadata() async {
    final files = await directory
        .list(recursive: true)
        .where((entity) => entity is File)
        .toList();
    _fileCount = files.length;

    final fileStats = await Future.wait(files.map((file) => file.stat()));
    _sizeInBytes = fileStats.fold<int>(0, (sum, stat) => sum + stat.size);

    notifyListeners();
  }
}
