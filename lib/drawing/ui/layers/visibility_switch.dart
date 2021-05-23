import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisibilitySwitch extends StatelessWidget {
  const VisibilitySwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: SizedBox(
        height: 52,
        width: 52,
        child: Icon(
          value ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
          size: 16,
        ),
      ),
    );
  }
}
