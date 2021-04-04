import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

void main() {
  group('ProjectSaveData should', () {
    test('encode', () {
      final data = ProjectSaveData(
        width: 200,
        height: 100,
        frames: [
          FrameModel(
            file: File('sample.png'),
            duration: Duration(seconds: 3),
          ),
        ],
        sounds: [
          SoundClip(
            file: File('sample.mp3'),
            startTime: Duration(seconds: 1),
            duration: Duration(seconds: 2),
          ),
        ],
      );
      expect(
        jsonEncode(data),
        '{"width":200.0,"height":100.0,"frames":[{"file_name":"sample.png","duration":"0:00:03.000000"}],"sounds":[{"file_name":"sample.mp3","start_time":"0:00:01.000000","duration":"0:00:02.000000"}]}',
      );
    });

    test('decode and encode back', () {
      final json =
          '{"width":200.0,"height":100.0,"frames":[{"file_name":"123.png","duration":"0:00:03.000000"}],"sounds":[{"file_name":"01234.mp3","start_time":"0:00:01.000000","duration":"0:00:02.000000"}]}';
      final data = ProjectSaveData.fromJson(jsonDecode(json), '', '');
      expect(jsonEncode(data), json);
    });
  });
}
