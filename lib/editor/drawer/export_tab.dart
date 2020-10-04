import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ExportTab extends StatelessWidget {
  const ExportTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    return Center(
      child: RaisedButton(
        child: Text(
          'Export GIF',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (await Permission.storage.request().isGranted) {
            final bytes = await makeGif(timeline.keyframes);
            final dir = await getTemporaryDirectory();
            final file = File(dir.path + '/animation.gif');
            await file.writeAsBytes(bytes);
            await ImageGallerySaver.saveFile(file.path);
          }
        },
      ),
    );
  }
}
