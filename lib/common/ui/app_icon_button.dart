import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key? key,
    this.icon,
    this.iconSize = 20,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final double iconSize;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: SizedBox(
          height: 44,
          width: 52,
          child: Icon(
            icon,
            color: _getColor(context),
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (selected) return Theme.of(context).colorScheme.primary;
    if (onTap == null) return Theme.of(context).disabledColor;
    return Theme.of(context).colorScheme.onSurface;
  }
}
