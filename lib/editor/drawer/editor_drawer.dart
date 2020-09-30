import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/frame/frame_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/drawer/export_tab.dart';
import 'package:mooltik/editor/easel/easel.dart';
import 'package:mooltik/editor/timeline/timeline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bar_icon_button.dart';

class EditorDrawer extends StatefulWidget {
  EditorDrawer({
    Key key,
    this.width = 200,
    this.quickAccessButtons,
  })  : assert(width != null),
        super(key: key);

  final double width;
  final List<BarIconButton> quickAccessButtons;

  @override
  _EditorDrawerState createState() => _EditorDrawerState();
}

class _EditorDrawerState extends State<EditorDrawer>
    with TickerProviderStateMixin {
  bool open = false;
  AnimationController _controller;
  Animation _openCloseAnimation;

  final tabs = <Widget>[
    Timeline(),
    ExportTab(),
  ];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..value = 1;
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
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Row(
          children: [
            SizedBox(width: 48),
            AnimatedBuilder(
              animation: _openCloseAnimation,
              child: _buildDrawerBody(),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-widget.width * _openCloseAnimation.value, 0),
                  child: child,
                );
              },
            ),
          ],
        ),
        _buildDrawerBar(),
      ],
    );
  }

  Widget _buildDrawerBody() {
    final frame = context.watch<FrameModel>();

    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 12)],
            ),
            child: IndexedStack(
              index: _selectedTabIndex,
              children: tabs,
            ),
          ),
          if (frame.undoAvailable)
            Positioned(
              top: 0,
              left: 56,
              child: EaselIconButton(
                icon: FontAwesomeIcons.undo,
                onTap: frame.undo,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerBar() {
    return Container(
      color: Colors.blueGrey[700],
      child: Column(
        children: [
          BarIconButton(
            icon: FontAwesomeIcons.film,
            selected: open && _selectedTabIndex == 0,
            onTap: () => _onTabTap(0),
          ),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.fileDownload,
            selected: open && _selectedTabIndex == 1,
            onTap: () => _onTabTap(1),
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
