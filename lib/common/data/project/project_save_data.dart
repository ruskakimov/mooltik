import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';

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
        scenes = (json[scenesKey] as List<dynamic>)
            .map((d) => Scene.fromJson(d, frameDirPath))
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
        soundsKey: sounds?.map((d) => d.toJson())?.toList() ?? [],
      };

  final double width;
  final double height;
  final List<Scene> scenes;
  final List<SoundClip> sounds;

  static const String widthKey = 'width';
  static const String heightKey = 'height';
  static const String scenesKey = 'scenes';
  static const String soundsKey = 'sounds';
}
