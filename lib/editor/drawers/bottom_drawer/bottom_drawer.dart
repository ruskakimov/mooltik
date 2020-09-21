import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:mooltik/editor/drawers/editor_drawer.dart';
import 'package:flutter/material.dart';
import 'package:mooltik/editor/timeline/timeline.dart';

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
        height: 48 * 4.0 + 8,
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
          child: _buildDrawerBody(),
        ),
      ),
    );
  }

  Widget _buildDrawerBody() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: _buildTimelineBar(),
        ),
        Expanded(
          child: Timeline(),
        ),
      ],
    );
  }

  Row _buildTimelineBar() {
    return Row(
      children: [
        DrawerIconButton(icon: FontAwesomeIcons.play),
        Spacer(),
        SizedBox(
          width: 96,
          child: Text(
            '1 F',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
