import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:mooltik/editor/reel/reel.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/drawer/export_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bar_icon_button.dart';

class ActionBar extends StatefulWidget {
  ActionBar({
    Key key,
    this.width = 112,
    this.quickAccessButtons,
  })  : assert(width != null),
        super(key: key);

  final double width;
  final List<BarIconButton> quickAccessButtons;

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> with TickerProviderStateMixin {
  bool open = false;
  AnimationController _controller;
  Animation _openCloseAnimation;

  final tabs = <Widget>[
    Reel(),
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
    return RepaintBoundary(
      child: Container(
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
    );
  }

  Widget _buildDrawerBar() {
    final reel = context.watch<ReelModel>();

    return Container(
      color: Colors.blueGrey[700],
      child: Column(
        children: [
          BarIconButton(
            icon: FontAwesomeIcons.film,
            selected: open && _selectedTabIndex == 0,
            onTap: () => _onTabTap(0),
          ),
          SizedBox(height: 48),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.play,
            onTap: reel.play,
          ),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.solidClone,
            selected: reel.onion,
            onTap: () {
              reel.onion = !reel.onion;
            },
          ),
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
