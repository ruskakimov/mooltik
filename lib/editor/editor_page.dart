import 'package:mooltik/editor/editor_model.dart';
import 'package:mooltik/editor/gif.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frame/easel.dart';
import 'toolbar/drawer_icon_button.dart';
import 'toolbar/editor_drawer.dart';
import 'toolbar/toolbar.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // _controller = AnimationController(
    //   lowerBound: 0,
    //   upperBound: _frames.length.toDouble(),
    //   duration: Duration(milliseconds: 1000 ~/ _fps),
    //   vsync: this,
    // );

    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     setState(() {
    //       _selectedFrameIndex = (_selectedFrameIndex + 1) % _frames.length;
    //     });
    //     _controller.reset();
    //     _controller.forward();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditorModel>();

    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      body: ChangeNotifierProvider.value(
        value: model.selectedFrame,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: Easel(
                  selectedTool: model.selectedTool,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: _buildTopDrawer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDrawer() {
    final model = context.watch<EditorModel>();
    final frame = model.selectedFrame;

    return EditorDrawer(
      height: 100,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ToolBar(
            value: model.selectedTool,
            onChanged: model.selectTool,
          ),
          _buildDownloadButton(),
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

  // Widget _buildPlayButton() {
  //   return FloatingActionButton(
  //     backgroundColor: Colors.red,
  //     child: Icon(
  //       _controller.isAnimating ? Icons.pause : Icons.play_arrow,
  //     ),
  //     onPressed: () {
  //       if (_controller.isAnimating) {
  //         _controller.stop();
  //         setState(() {});
  //       } else {
  //         _controller.forward(from: _selectedFrameIndex.toDouble());
  //       }
  //     },
  //   );
  // }

  Widget _buildDownloadButton() {
    final frames = context.watch<EditorModel>().frames;

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
