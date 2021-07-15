import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mooltik/common/ui/labeled_icon_button.dart';

class SlideActionButton extends StatelessWidget {
  const SlideActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  }) : super(key: key);

  /// Must be an icon from the material design icons font.
  final IconData icon;

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      closeOnTap: true,
      child: Container(
        margin: EdgeInsets.only(left: 8),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LabeledIconButton(
          icon: icon,
          iconSize: 20,
          label: label,
          color: Colors.white,
          onTap: onTap,
        ),
      ),
    );
  }
}
