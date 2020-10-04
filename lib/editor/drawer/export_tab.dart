import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
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

    final timeline = context.watch<TimelineModel>();
    return Center(
      child: RaisedButton(
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

          if (await Permission.storage.request().isGranted) {
            final bytes = await makeGif(timeline.keyframes);
            final dir = await getTemporaryDirectory();
            final file = File(dir.path + '/animation.gif');
            await file.writeAsBytes(bytes);
            await ImageGallerySaver.saveFile(file.path);
          }

          setState(() {
            _saving = false;
          });
        },
      ),
    );
  }
}
