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
    return Transform.scale(
      scale: 0.6,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onTap,
        ),
      ),
    );
  }
}
