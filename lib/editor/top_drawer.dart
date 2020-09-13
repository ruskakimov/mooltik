import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mooltik/editor/frame/frame.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:mooltik/editor/toolbar/drawer_icon_button.dart';
import 'package:mooltik/editor/toolbar/toolbar.dart';
import 'package:mooltik/editor/editor_model.dart';
import 'package:mooltik/editor/toolbar/editor_drawer.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditorModel>();
    final frame = context.watch<Frame>();

    return EditorDrawer(
      height: 100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToolBar(
                value: model.selectedTool,
                onChanged: model.selectTool,
              ),
              _buildDownloadButton(model.frames),
            ],
          ),
          Row(
            children: [
              _buildStrokeWidthButton(),
            ],
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

  Widget _buildStrokeWidthButton() {
    return DrawerIconButton(
      icon: Icons.fiber_manual_record,
      onTap: () {},
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
