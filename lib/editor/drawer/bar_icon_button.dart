import 'package:flutter/material.dart';

class BarIconButton extends StatelessWidget {
  const BarIconButton({
    Key key,
    this.icon,
    this.selected = false,
    this.onTap,
    this.label,
  }) : super(key: key);

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 44,
        width: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: _getColor(),
              size: 20,
            ),
            if (label != null)
              Positioned(
                top: 8,
                left: 4,
                child: Text(
                  '$label',
                  style: TextStyle(
                    fontSize: 10,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
              ),
          ],
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
