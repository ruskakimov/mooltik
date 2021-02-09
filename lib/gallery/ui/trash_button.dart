import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';

class TrashButton extends StatelessWidget {
  const TrashButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupWithArrowEntry(
      visible: false,
      arrowSide: ArrowSide.top,
      arrowSidePosition: ArrowSidePosition.end,
      popupBody: SizedBox(width: 200, height: 300),
      child: AppIconButton(
        icon: FontAwesomeIcons.trashAlt,
      ),
    );
  }
}
