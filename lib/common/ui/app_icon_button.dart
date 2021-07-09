import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key? key,
    required this.icon,
    this.iconSize = 20,
    this.selected = false,
    this.onTap,
  })  : svgPath = null,
        super(key: key);

  const AppIconButton.svg({
    Key? key,
    required this.svgPath,
    this.selected = false,
    this.onTap,
  })  : icon = null,
        iconSize = null,
        super(key: key);

  final IconData? icon;
  final double? iconSize;

  final String? svgPath;

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
          child: svgPath != null
              ? SvgPicture.asset(
                  svgPath!,
                  fit: BoxFit.none,
                  color: _getColor(context),
                )
              : Icon(
                  icon,
                  size: iconSize,
                  color: _getColor(context),
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
