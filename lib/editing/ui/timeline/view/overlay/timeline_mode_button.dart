import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimelineModeButton extends StatelessWidget {
  const TimelineModeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      elevation: 2,
      child: _buildIcon(),
      onPressed: () {},
    );
  }

  Widget _buildIcon() {
    return RotatedBox(
      quarterTurns: 2,
      child: Icon(FontAwesomeIcons.windowMaximize, size: 20),
    );
    return Icon(FontAwesomeIcons.stream, size: 20);
  }
}
