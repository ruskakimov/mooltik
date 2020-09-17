import 'package:flutter/material.dart';

class DrawerIconButton extends StatelessWidget {
  const DrawerIconButton({
    Key key,
    this.icon,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        width: 48,
        child: Icon(
          icon,
          color: _getColor(),
        ),
      ),
    );
  }

  Color _getColor() {
    if (selected) return Colors.amber;
    if (onTap == null) return Colors.grey[600];
    return Colors.grey[200];
  }
}
