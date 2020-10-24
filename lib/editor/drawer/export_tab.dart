import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image/image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ExportTab extends StatefulWidget {
  const ExportTab({Key key}) : super(key: key);

  @override
  _ExportTabState createState() => _ExportTabState();
}

class _ExportTabState extends State<ExportTab> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    if (_saving)
      return Center(
        child: Text('Saving...'),
      );

    final reel = context.watch<ReelModel>();
    return Center(
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 12, right: 4),
              title: Text('Onion'),
              trailing: Switch(
                activeColor: Colors.amber,
                value: reel.onion,
                onChanged: (value) => reel.onion = value,
              ),
              onTap: () {
                reel.onion = !reel.onion;
              },
            ),
          ),
          Spacer(),
          ListTile(
            contentPadding: EdgeInsets.only(left: 12, right: 12),
            title: Text('Save GIF'),
            trailing: Icon(Icons.image),
          ),
          RaisedButton(
            child: Text(
              'Save GIF',
              style: TextStyle(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              setState(() {
                _saving = true;
              });
              await _saveGif(reel.frames, reel.frameDurations);
              setState(() {
                _saving = false;
              });
            },
          ),
          RaisedButton(
            child: Text(
              'Save video',
              style: TextStyle(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              setState(() {
                _saving = true;
              });
              await _saveVideo(reel.frames, reel.frameDurations);
              setState(() {
                _saving = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveGif(
    List<FrameModel> frames,
    List<int> durations,
  ) async {
    if (await Permission.storage.request().isGranted) {
      final bytes = await makeGif(frames, durations);
      final dir = await getTemporaryDirectory();
      final file = File(dir.path + '/animation.gif');
      await file.writeAsBytes(bytes);
      await ImageGallerySaver.saveFile(file.path);
    }
  }

  Future<void> _saveVideo(
    List<FrameModel> frames,
    List<int> durations,
  ) async {
    if (await Permission.storage.request().isGranted) {
      final dir = await getTemporaryDirectory();

      final pngFiles = <File>[];

      frames = frames.where((f) => f != null).toList();
      durations = durations.where((d) => d > 0).toList();

      // Save frames as PNG images.
      for (int i = 0; i < frames.length; i++) {
        final img = await imageFromFrame(frames[i]);
        final pngBytes = encodePng(img, level: 0);
        final frameFile = File(dir.path + '/frame$i.png');
        await frameFile.writeAsBytes(pngBytes);
        pngFiles.add(frameFile);
        print(frameFile.path);
      }

      // Create concat demuxer file for ffmpeg.
      final concatDemuxer = File(dir.path + '/concat.txt');
      String content = '';
      for (int i = 0; i < frames.length; i++) {
        final durationInSeconds = durations[i] / 24.0;
        content +=
            'file \'${pngFiles[i].path}\'\nduration ${durationInSeconds.toStringAsFixed(6)}\n';
      }
      content += 'file \'${pngFiles.last.path}\'';
      await concatDemuxer.writeAsString(content);

      // Output video file.
      final video = File(dir.path + '/mooltik_video.mp4');

      final ffmpeg = FlutterFFmpeg();
      final rc = await ffmpeg.execute(
          '-y -f concat -safe 0 -i ${concatDemuxer.path} -vf fps=24 -pix_fmt yuv420p ${video.path}');
      print('>>> result: $rc');

      await ImageGallerySaver.saveFile(video.path);
    }
  }
}
