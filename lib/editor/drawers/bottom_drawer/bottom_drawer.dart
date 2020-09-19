import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:mooltik/editor/drawers/editor_drawer.dart';
import 'package:flutter/material.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(math.pi),
      child: EditorDrawer(
        height: 100,
        quickAccessButtons: [
          DrawerIconButton(
            icon: FontAwesomeIcons.stepBackward,
          ),
          DrawerIconButton(
            icon: FontAwesomeIcons.stepForward,
          ),
        ],
        body: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(math.pi),
          child: Text('hello'),
        ),
      ),
    );
  }
}
