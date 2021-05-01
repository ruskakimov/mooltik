import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';

class ProjectSaveData {
  ProjectSaveData({
    this.width,
    this.height,
    this.scenes,
    this.sounds,
  });

  ProjectSaveData.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    String soundDirPath,
  )   : width = json[_widthKey],
        height = json[_heightKey],
        scenes = _parseScenes(json, frameDirPath),
        sounds = json[_soundsKey] != null
            ? (json[_soundsKey] as List<dynamic>)
                .map((d) => SoundClip.fromJson(d, soundDirPath))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        _widthKey: width,
        _heightKey: height,
        _scenesKey: scenes.map((d) => d.toJson()).toList(),
        _soundsKey: sounds?.map((d) => d.toJson())?.toList() ?? [],
      };

  final double width;
  final double height;
  final List<Scene> scenes;
  final List<SoundClip> sounds;

  static List<Scene> _parseScenes(
    Map<String, dynamic> json,
    String frameDirPath,
  ) {
    // Latest format.
    if (json.containsKey(_scenesKey)) {
      return (json[_scenesKey] as List<dynamic>)
          .map((d) => Scene.fromJson(d, frameDirPath))
          .toList();
    }

    // Convert v0.8 format to the latest.
    if (json.containsKey(_legacyFramesKey)) {
      final frameSeq = Sequence<Frame>(
        (json[_legacyFramesKey] as List<dynamic>)
            .map((d) => Frame.fromLegacyJsonWithId(d, frameDirPath))
            .toList(),
      );
      return [
        Scene(
          frameSeq: frameSeq,
          duration: frameSeq.totalDuration,
          playMode: PlayMode.loop, // Showcase new loop feature.
        )
      ];
    }

    throw Exception('Unable to parse project scenes.');
  }
}

const String _widthKey = 'width';
const String _heightKey = 'height';
const String _scenesKey = 'scenes';
const String _soundsKey = 'sounds';

const String _legacyFramesKey = 'frames';
