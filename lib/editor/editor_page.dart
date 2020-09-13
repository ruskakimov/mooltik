import 'package:mooltik/editor/editor_model.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/top_drawer.dart';
import 'package:provider/provider.dart';

import 'frame/easel.dart';

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
                child: TopDrawer(),
              ),
            ],
          ),
        ),
      ),
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
}
