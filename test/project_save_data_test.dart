import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/project/project_save_data.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';

void main() {
  group('ProjectSaveData should', () {
    test('encode', () {
      final data = ProjectSaveData(
        width: 200,
        height: 100,
        scenes: [
          SceneModel(
            duration: Duration(seconds: 12),
            frameSeq: Sequence([
              FrameModel(
                file: File('1.png'),
                duration: Duration(seconds: 3),
              ),
              FrameModel(
                file: File('2.png'),
                duration: Duration(seconds: 2),
              ),
            ]),
          ),
          SceneModel(
            duration: Duration(seconds: 4),
            frameSeq: Sequence([
              FrameModel(
                file: File('3.png'),
                duration: Duration(seconds: 1),
              ),
              FrameModel(
                file: File('4.png'),
                duration: Duration(seconds: 10),
              ),
            ]),
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
        '''{
          "width":200.0,
          "height":100.0,
          "scenes":[
            {
              "frames": [
                {
                  "file_name":"1.png",
                  "duration":"0:00:03.000000"
                },
                {
                  "file_name":"2.png",
                  "duration":"0:00:02.000000"
                }
              ],
              "duration":"0:00:12.000000",
              "play_mode": 0
            },
            {
              "frames": [
                {
                  "file_name":"3.png",
                  "duration":"0:00:01.000000"
                },
                {
                  "file_name":"4.png",
                  "duration":"0:00:10.000000"
                }
              ],
              "duration":"0:00:04.000000",
              "play_mode": 0
            }
          ],
          "sounds":[
            {
              "file_name":"sample.mp3",
              "start_time":"0:00:01.000000",
              "duration":"0:00:02.000000"
            }
          ]
        }'''
            .replaceAll(RegExp(r'\s'), ''),
      );
    });

    test('decode and encode back', () {
      final json = '''{
            "width":200.0,
            "height":100.0,
            "scenes":[
              {
                "frames": [
                  {
                    "file_name":"1.png",
                    "duration":"0:00:03.000000"
                  },
                  {
                    "file_name":"2.png",
                    "duration":"0:00:02.000000"
                  }
                ],
                "duration":"0:00:12.000000",
                "play_mode": 0
              },
              {
                "frames": [
                  {
                    "file_name":"3.png",
                    "duration":"0:00:01.000000"
                  },
                  {
                    "file_name":"4.png",
                    "duration":"0:00:10.000000"
                  }
                ],
                "duration":"0:00:04.000000",
                "play_mode": 2
              }
            ],
            "sounds":[
              {
                "file_name":"01234.mp3",
                "start_time":"0:00:01.000000",
                "duration":"0:00:02.000000"
              }
            ]
          }'''
          .replaceAll(RegExp(r'\s'), '');
      final data = ProjectSaveData.fromJson(jsonDecode(json), '', '');
      expect(jsonEncode(data), json);
    });
  });
}
