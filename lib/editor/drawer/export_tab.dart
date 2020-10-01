import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
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
          final bytes = await makeGif(timeline.keyframes);
          await Share.file('Share GIF', 'image.gif', bytes, 'image/gif');
        },
      ),
    );
  }
}
