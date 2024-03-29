import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  const LabeledIconButton({
    Key? key,
    required this.icon,
    this.iconSize,
    this.iconTransform,
    required this.label,
    this.color,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final double? iconSize;
  final Matrix4? iconTransform;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkResponse(
        radius: 56,
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.5 : 1,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform(
                  transform: iconTransform ?? Matrix4.identity(),
                  child: Icon(
                    icon,
                    size: iconSize ?? 18,
                    color: color ?? Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color ?? Theme.of(context).colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
