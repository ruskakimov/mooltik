import 'package:mooltik/common/data/duration_methods.dart';

class SaveDataTranscoder {
  bool is_v0_8(Map<String, dynamic> json) => json.containsKey('frames');

  Map<String, dynamic> convert_v0_8_to_v0_9(Map<String, dynamic> json) {
    if (!is_v0_8(json)) throw Exception('Data is not in v0.8 format.');

    final frames = json['frames'] as List;
    final totalDuration = frames.fold(
      Duration.zero,
      (d, frame) => d + (frame['duration'] as String).parseDuration(),
    );

    return {
      'width': json['width'],
      'height': json['height'],
      'scenes': [
        {
          'frames': frames
              .map((frameData) => {
                    'file_name': 'frame${frameData['id']}.png',
                    'duration': frameData['duration'],
                  })
              .toList(),
          'duration': totalDuration.toString(),
          'play_mode': 1,
        }
      ],
      'sounds': json['sounds'],
    };
  }

  bool is_v0_9(Map<String, dynamic> json) => null;

  Map<String, dynamic> convert_v0_9_to_v1_0(Map<String, dynamic> json) {
    if (!is_v0_9(json)) throw Exception('Data is not in v0.9 format.');
  }
}
