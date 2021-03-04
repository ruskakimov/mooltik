import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key key,
    this.icon,
    this.selected = false,
    this.selectedColor = Colors.black,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      child: InkResponse(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: SizedBox(
          height: 44,
          width: 52,
          child: Icon(
            icon,
            color: _getColor(context),
            size: 20,
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (selected) return selectedColor;
    if (onTap == null) return Theme.of(context).disabledColor;
    return Theme.of(context).colorScheme.onSurface;
  }
}
