import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mooltik/editor/drawer/animated_drawer.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:mooltik/home/png.dart';
import 'package:mooltik/home/project.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    Key key,
    this.open,
  }) : super(key: key);

  final bool open;

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedLeftDrawer(
      width: 200,
      open: widget.open,
      child: _saving
          ? Center(
              child: Text('Saving...'),
            )
          : _buildMenu(),
    );
  }

  Widget _buildMenu() {
    final reel = context.watch<ReelModel>();

    return Column(
      children: [
        // MenuListTile(
        //   icon: Icons.lightbulb_outline,
        //   title: 'Onion',
        //   trailing: Switch(
        //     activeColor: Theme.of(context).colorScheme.primary,
        //     value: reel.onion,
        //     onChanged: (value) => reel.onion = value,
        //   ),
        //   onTap: () {
        //     reel.onion = !reel.onion;
        //   },
        // ),
        Spacer(),
        MenuListTile(
          icon: Icons.image,
          title: 'Save GIF',
          onTap: () async {
            setState(() {
              _saving = true;
            });
            await _saveGif(reel.frames);
            setState(() {
              _saving = false;
            });
          },
        ),
        MenuListTile(
          icon: Icons.videocam,
          title: 'Save MP4',
          onTap: () async {
            setState(() {
              _saving = true;
            });
            await _saveVideo(reel.frames);
            setState(() {
              _saving = false;
            });
          },
        ),
        MenuListTile(
          icon: Icons.exit_to_app,
          title: 'Save and exit',
          onTap: () async {
            setState(() {
              _saving = true;
            });
            final project = context.read<Project>();
            await project.save();
            project.close();
            Navigator.of(context).pop();
            setState(() {
              _saving = false;
            });
          },
        ),
      ],
    );
  }

  Future<void> _saveGif(List<FrameModel> frames) async {
    if (await Permission.storage.request().isGranted) {
      final bytes = await makeGif(frames);
      final dir = await getTemporaryDirectory();
      final file = File(dir.path + '/animation.gif');
      await file.writeAsBytes(bytes);
      await ImageGallerySaver.saveFile(file.path);
    }
  }

  Future<void> _saveVideo(List<FrameModel> frames) async {
    if (await Permission.storage.request().isGranted) {
      final tempDir = await getTemporaryDirectory();

      final pngFiles = <File>[];
      final futures = <Future<void>>[];

      // Save frames as PNG images.
      for (int i = 0; i < frames.length; i++) {
        final frame = frames[i];
        final picture = pictureFromFrame(frame);
        final frameFile = File(tempDir.path + '/frame$i.png');
        final future = pngWrite(
          frameFile,
          await picture.toImage(frame.width.toInt(), frame.height.toInt()),
        );
        futures.add(future);
        pngFiles.add(frameFile);
      }
      await Future.wait(futures);

      // Create concat demuxer file for ffmpeg.
      final concatDemuxer = File(tempDir.path + '/concat.txt');
      String content = '';
      for (int i = 0; i < frames.length; i++) {
        final durationInSeconds = frames[i].duration.inMilliseconds / 1000;
        content +=
            'file \'${pngFiles[i].path}\'\nduration ${durationInSeconds.toStringAsFixed(6)}\n';
      }
      content += 'file \'${pngFiles.last.path}\'';
      await concatDemuxer.writeAsString(content);

      // Output video file.
      final video = File(tempDir.path + '/mooltik_video.mp4');

      final ffmpeg = FlutterFFmpeg();
      final rc = await ffmpeg.execute(
          '-y -f concat -safe 0 -i ${concatDemuxer.path} -vf fps=24 -pix_fmt yuv420p ${video.path}');
      print('>>> result: $rc');

      await ImageGallerySaver.saveFile(video.path);
    }
  }
}

class MenuListTile extends StatelessWidget {
  const MenuListTile({
    Key key,
    this.icon,
    this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(icon),
        title: Transform.translate(
          offset: Offset(-18, 0),
          child: Text(title),
        ),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}
