import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawer/bar_icon_button.dart';
import 'package:mooltik/editor/drawer/pallete_tab/color_picker.dart';
import 'package:mooltik/editor/reel/reel.dart';
import 'package:mooltik/editor/reel/reel_model.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/toolbox/toolbox_model.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> with TickerProviderStateMixin {
  bool rightOpen = false;
  AnimationController _rightController;
  Animation _rightAnimation;

  bool leftOpen = false;
  AnimationController _leftController;
  Animation _leftAnimation;

  @override
  void initState() {
    super.initState();
    _rightController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..value = 1.0;
    _rightAnimation = CurvedAnimation(
      parent: _rightController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _leftController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..value = 1.0;
    _leftAnimation = CurvedAnimation(
      parent: _leftController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final reel = context.watch<ReelModel>();

    final bar = ColoredBox(
      color: Colors.blueGrey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          BarIconButton(
            icon: FontAwesomeIcons.bars,
            onTap: () {},
          ),
          BarIconButton(
            icon: FontAwesomeIcons.film,
            selected: leftOpen,
            onTap: () {
              _toggleLeftDrawer();
            },
          ),
          BarIconButton(
            icon: FontAwesomeIcons.solidLemon,
            selected: reel.onion,
            onTap: () {
              reel.onion = !reel.onion;
            },
          ),
          Spacer(),
          BarIconButton(
            icon: FontAwesomeIcons.play,
            onTap: reel.play,
          ),
          Spacer(),
          for (var i = 0; i < toolbox.tools.length; i++)
            BarIconButton(
              icon: toolbox.tools[i].icon,
              selected: toolbox.tools[i] == toolbox.selectedTool,
              onTap: () {
                if (toolbox.tools[i] == toolbox.selectedTool) {
                  _toggleRightDrawer();
                }
                toolbox.selectTool(i);
              },
            ),
          ColorPicker(),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bar,
        Expanded(
          child: _buildDrawerArea(),
        ),
      ],
    );
  }

  Widget _buildDrawerArea() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 112,
          child: AnimatedBuilder(
            animation: _leftAnimation,
            child: Container(
              color: Colors.blueGrey[800],
              child: Reel(),
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-112.0 * _leftAnimation.value, 0),
                child: child,
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _rightAnimation,
            child: _buildDrawerBody(),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(64.0 * _rightAnimation.value, 0),
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerBody() {
    return RepaintBoundary(
      child: Container(
        width: 64,
        color: Colors.blueGrey[800],
        child: SizeSelector(),
      ),
    );
  }

  void _toggleRightDrawer() {
    setState(() {
      rightOpen = !rightOpen;
    });
    _animateRightDrawer();
  }

  void _animateRightDrawer() {
    if (rightOpen) {
      _rightController.reverse();
    } else {
      _rightController.forward();
    }
  }

  void _toggleLeftDrawer() {
    setState(() {
      leftOpen = !leftOpen;
    });
    _animateLeftDrawer();
  }

  void _animateLeftDrawer() {
    if (leftOpen) {
      _leftController.reverse();
    } else {
      _leftController.forward();
    }
  }
}

class SizeSelector extends StatelessWidget {
  const SizeSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolbox = context.watch<ToolboxModel>();
    final width = toolbox.selectedTool.paint.strokeWidth;
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              '${width.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: width,
              min: 1.0,
              max: 100.0,
              onChanged: (value) {
                toolbox.changeToolWidth(value.round());
              },
            ),
          ),
        ),
      ],
    );
  }
}
