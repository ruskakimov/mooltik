import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
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
        height: 44,
        width: 44,
        child: Icon(
          icon,
          color: _getColor(),
          size: 20,
        ),
      ),
    );
  }

  Color _getColor() {
    if (selected) return Colors.amber;
    if (onTap == null) return Colors.grey[200].withOpacity(0.4);
    return Colors.grey[200];
  }
}
