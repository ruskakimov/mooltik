import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawer_icon_button.dart';

const innerBorderRadius = 16.0;
const outerBorderRadius = 16.0;

class EditorDrawer extends StatefulWidget {
  EditorDrawer({
    Key key,
    this.height,
    this.body,
    this.quickAccessButtons,
  })  : assert(height != null),
        assert(body != null),
        super(key: key);

  final double height;
  final Widget body;
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
          offset: Offset(0, -widget.height * _animation.value),
          child: child,
        );
      },
    );
  }

  Widget _buildDrawerBody() {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(
            child: SizedBox(
              height: widget.height,
              child: widget.body,
            ),
          ),
          Row(
            children: [
              DrawerIconButton(
                icon: open
                    ? FontAwesomeIcons.chevronUp
                    : FontAwesomeIcons.chevronDown,
                onTap: _toggleDrawer,
              ),
              Spacer(),
              if (widget.quickAccessButtons != null)
                ...widget.quickAccessButtons,
            ],
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
