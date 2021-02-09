import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';

class BinButton extends StatefulWidget {
  const BinButton({
    Key key,
  }) : super(key: key);

  @override
  _BinButtonState createState() => _BinButtonState();
}

class _BinButtonState extends State<BinButton> {
  bool _trashOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupWithArrowEntry(
      visible: _trashOpen,
      arrowSide: ArrowSide.top,
      arrowSidePosition: ArrowSidePosition.end,
      popupBody: SizedBox(width: 200, height: 300),
      child: AppIconButton(
        icon: FontAwesomeIcons.trashAlt,
        onTap: () {
          setState(() => _trashOpen = true);
        },
      ),
      onTapOutside: () {
        setState(() => _trashOpen = false);
      },
    );
  }
}
