import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
                _buildColorButton(toolbox.selectedTool.paint.color),
              SizedBox(width: 8),
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

  Widget _buildColorButton(Color selectedColor) {
    return GestureDetector(
      onTap: _showColorPicker,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selectedColor,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    final toolbox = context.read<Toolbox>();
    showDialog(
      context: context,
      child: AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: toolbox.selectedTool.paint.color,
            onColorChanged: (color) {
              toolbox.changeColor(color);
            },
            showLabel: false,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
      ),
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
