import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

class ProjectSaveData {
  ProjectSaveData({
    required this.width,
    required this.height,
    required this.scenes,
    required this.sounds,
  });

  ProjectSaveData.fromJson(
    Map<String, dynamic> json,
    String frameDirPath,
    String soundDirPath,
  )   : width = (json[widthKey] as num).toInt(),
        height = (json[heightKey] as num).toInt(),
        scenes = (json[scenesKey] as List<dynamic>)
            .map((d) => Scene.fromJson(
                  d,
                  frameDirPath,
                  (json[widthKey] as num).toInt(),
                  (json[heightKey] as num).toInt(),
                ))
            .toList(),
        sounds = json[soundsKey] != null
            ? (json[soundsKey] as List<dynamic>)
                .map((d) => SoundClip.fromJson(d, soundDirPath))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        widthKey: width,
        heightKey: height,
        scenesKey: scenes.map((d) => d.toJson()).toList(),
        soundsKey: sounds.map((d) => d.toJson()).toList(),
      };

  final int width;
  final int height;
  final List<Scene> scenes;
  final List<SoundClip> sounds;

  static const String widthKey = 'width';
  static const String heightKey = 'height';
  static const String scenesKey = 'scenes';
  static const String soundsKey = 'sounds';
}
