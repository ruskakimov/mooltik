import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/drawer/pallete_tab/pallete_tab.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
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
    with TickerProviderStateMixin {
  bool open = true;
  AnimationController _controller;
  Animation _openCloseAnimation;

  final tabs = [
    PalleteTab(),
    Timeline(),
  ];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _openCloseAnimation = CurvedAnimation(
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
      animation: _openCloseAnimation,
      child: _buildDrawerBody(),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.height * _openCloseAnimation.value),
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
                selected: open && _selectedTabIndex == 0,
                onTap: () => _onTabTap(0),
              ),
              DrawerIconButton(
                icon: FontAwesomeIcons.film,
                selected: open && _selectedTabIndex == 1,
                onTap: () => _onTabTap(1),
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
              child: tabs[_selectedTabIndex],
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTap(int tabIndex) {
    if (_selectedTabIndex == tabIndex && open) {
      _closeDrawer();
    } else {
      setState(() {
        _selectedTabIndex = tabIndex;
      });
      if (!open) _openDrawer();
    }
  }

  void _openDrawer() {
    setState(() {
      open = true;
    });
    _animateDrawer();
  }

  void _closeDrawer() {
    setState(() {
      open = false;
    });
    _animateDrawer();
  }

  void _animateDrawer() {
    if (open) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
