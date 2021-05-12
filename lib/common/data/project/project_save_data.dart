import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
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
  )   : width = json[widthKey],
        height = json[heightKey],
        scenes = _parseScenes(json, frameDirPath),
        sounds = json[soundsKey] != null
            ? (json[soundsKey] as List<dynamic>)
                .map((d) => SoundClip.fromJson(d, soundDirPath))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        widthKey: width,
        heightKey: height,
        scenesKey: scenes.map((d) => d.toJson()).toList(),
        soundsKey: sounds?.map((d) => d.toJson())?.toList() ?? [],
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
    if (json.containsKey(scenesKey)) {
      return (json[scenesKey] as List<dynamic>)
          .map((d) => Scene.fromJson(d, frameDirPath))
          .toList();
    }

    // Convert v0.8 format to the latest.
    if (json.containsKey(legacyFramesKey)) {
      final frameSeq = Sequence<Frame>(
        (json[legacyFramesKey] as List<dynamic>)
            .map((d) => Frame.fromLegacyJsonWithId(d, frameDirPath))
            .toList(),
      );
      return [
        Scene(
          layers: [SceneLayer(frameSeq, PlayMode.loop)],
          duration: frameSeq.totalDuration,
        )
      ];
    }

    throw Exception('Unable to parse project scenes.');
  }

  static const String widthKey = 'width';
  static const String heightKey = 'height';
  static const String scenesKey = 'scenes';
  static const String soundsKey = 'sounds';

  static const String legacyFramesKey = 'frames';
}
