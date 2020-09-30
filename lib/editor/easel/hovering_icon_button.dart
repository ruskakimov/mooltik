import 'package:flutter/material.dart';

class HoveringIconButton extends StatelessWidget {
  const HoveringIconButton({
    Key key,
    @required this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(2, 2),
          child: Icon(
            icon,
            color: onTap != null ? Colors.blueGrey : Colors.transparent,
          ),
        ),
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: onTap,
        ),
      ],
    );
  }
}
