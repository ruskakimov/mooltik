import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Transform.translate(
        offset: Offset(0, 1),
        child: Icon(icon, size: 20),
      ),
      title: Transform.translate(
        offset: Offset(-18, 0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
