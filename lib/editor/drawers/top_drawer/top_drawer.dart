import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/toolbox/toolbox.dart';
import 'package:provider/provider.dart';

import 'package:mooltik/editor/frame/frame.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:mooltik/editor/drawers/top_drawer/toolbar.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
import 'package:mooltik/editor/drawers/editor_drawer.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<Timeline>();
    final toolbox = context.watch<Toolbox>();
    final frame = context.watch<Frame>();

    return EditorDrawer(
      height: 110,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToolBar(),
              _buildDownloadButton(timeline.frames),
            ],
          ),
          Slider(
            value: toolbox.selectedTool.paint.strokeWidth,
            min: 2.0,
            max: 100.0,
            onChanged: (value) {
              toolbox.changeStrokeWidth(value);
            },
          ),
        ],
      ),
      quickAccessButtons: [
        DrawerIconButton(
          icon: Icons.undo,
          onTap: frame.undoAvailable ? frame.undo : null,
        ),
        DrawerIconButton(
          icon: Icons.redo,
          onTap: frame.redoAvailable ? frame.redo : null,
        ),
      ],
    );
  }

  Widget _buildDownloadButton(List<Frame> frames) {
    return IconButton(
      icon: Icon(
        Icons.file_download,
        color: Colors.grey,
      ),
      onPressed: () async {
        final bytes = await makeGif(frames, 24);
        await Share.file('Share GIF', 'image.gif', bytes, 'image/gif');
      },
    );
  }
}
