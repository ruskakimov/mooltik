import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/pallete_tab/pallete_tab.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/frame/frame_model.dart';

import 'drawer_icon_button.dart';

class EditorDrawer extends StatefulWidget {
  EditorDrawer({
    Key key,
    this.height = 200,
    this.quickAccessButtons,
  })  : assert(height != null),
        super(key: key);

  final double height;
  final List<DrawerIconButton> quickAccessButtons;

  @override
  _EditorDrawerState createState() => _EditorDrawerState();
}

class _EditorDrawerState extends State<EditorDrawer>
    with SingleTickerProviderStateMixin {
  bool open = true;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: _buildDrawerBody(),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.height * _animation.value),
          child: child,
        );
      },
    );
  }

  Widget _buildDrawerBody() {
    final frame = context.watch<FrameModel>();

    return Container(
      width: double.infinity,
      color: Colors.blueGrey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DrawerIconButton(
                icon: FontAwesomeIcons.palette,
                onTap: _toggleDrawer,
                selected: true,
              ),
              DrawerIconButton(
                icon: FontAwesomeIcons.film,
                onTap: _toggleDrawer,
              ),
              Spacer(),
              DrawerIconButton(
                icon: FontAwesomeIcons.undo,
                onTap: frame.undoAvailable ? frame.undo : null,
              ),
              DrawerIconButton(
                icon: FontAwesomeIcons.redo,
                onTap: frame.redoAvailable ? frame.redo : null,
              ),
            ],
          ),
          RepaintBoundary(
            child: Container(
              height: widget.height,
              color: Colors.blueGrey[900],
              child: PalleteTab(),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDrawer() {
    setState(() {
      open = !open;
    });
    if (open) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
