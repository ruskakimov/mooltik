import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisibilitySwitch extends StatefulWidget {
  const VisibilitySwitch({
    Key key,
  }) : super(key: key);

  @override
  _VisibilitySwitchState createState() => _VisibilitySwitchState();
}

class _VisibilitySwitchState extends State<VisibilitySwitch> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _open = !_open;
        });
      },
      child: SizedBox(
        height: 52,
        width: 52,
        child: Icon(
          _open ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
          size: 16,
        ),
      ),
    );
  }
}
