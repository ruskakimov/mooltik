import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideActionButton extends StatelessWidget {
  const SlideActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.rightSide = true,
  }) : super(key: key);

  /// Must be an icon from the material design icons font.
  final IconData icon;

  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool rightSide;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        highlightColor: Colors.transparent, // Remove square splash.
      ),
      child: SlideAction(
        closeOnTap: true,
        onTap: onTap,
        child: Container(
          margin: rightSide
              ? const EdgeInsets.only(left: 8)
              : const EdgeInsets.only(right: 8),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Opacity(
            opacity: onTap == null ? 0.5 : 1,
            child: _buildLabeledIcon(),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
