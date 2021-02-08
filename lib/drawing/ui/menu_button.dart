import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_entry.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/drawing/ui/drawing_menu.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    Key key,
  }) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupEntry(
      visible: _menuOpen,
      // popupAnchor: Alignment(
      //   -1.0 + _arrowLeftOffset * 2 / widget.menuWidth,
      //   -1.0,
      // ),
      popup: PopupWithArrow(
        child: DrawingMenu(
          onDone: () {
            setState(() => _menuOpen = false);
          },
        ),
      ),
      child: AppIconButton(
        icon: FontAwesomeIcons.ellipsisV,
        onTap: () {
          setState(() => _menuOpen = true);
        },
      ),
      onTapOutside: () {
        setState(() => _menuOpen = false);
      },
    );
  }
}
