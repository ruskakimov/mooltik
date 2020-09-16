import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawers/top_drawer/color_picker.dart';
import 'package:mooltik/editor/toolbox/toolbox.dart';
import 'package:mooltik/editor/toolbox/tools.dart';
import 'package:provider/provider.dart';

import 'package:mooltik/editor/frame/frame.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:mooltik/editor/drawers/top_drawer/toolbar.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
import 'package:mooltik/editor/drawers/editor_drawer.dart';

class TopDrawer extends StatefulWidget {
  const TopDrawer({Key key}) : super(key: key);

  @override
  _TopDrawerState createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
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
            children: [
              ToolBar(),
              Spacer(),
              if (toolbox.selectedTool is Pencil)
                ColorPicker(color: toolbox.selectedTool.paint.color),
              SizedBox(width: 8),
              _buildDownloadButton(timeline.frames),
            ],
          ),
          _buildWidthSelector(toolbox),
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

  Row _buildWidthSelector(Toolbox toolbox) {
    final width = context.watch<Toolbox>().selectedTool.paint.strokeWidth;
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            '${width.toStringAsFixed(0)}',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Slider(
            value: width,
            min: 1.0,
            max: 100.0,
            onChanged: (value) {
              toolbox.changeStrokeWidth(value.round());
            },
          ),
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
