import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/gallery/ui/bin_contents.dart';

class BinButton extends StatefulWidget {
  const BinButton({
    Key key,
  }) : super(key: key);

  @override
  _BinButtonState createState() => _BinButtonState();
}

class _BinButtonState extends State<BinButton> {
  bool _binOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupWithArrowEntry(
      visible: _binOpen,
      arrowSide: ArrowSide.top,
      arrowSidePosition: ArrowSidePosition.end,
      popupBody: SizedBox(
        width: 200,
        height: (MediaQuery.of(context).size.height - 70).clamp(0.0, 500.0),
        child: BinContents(),
      ),
      child: AppIconButton(
        icon: FontAwesomeIcons.trashAlt,
        onTap: () {
          setState(() => _binOpen = true);
        },
      ),
      onTapOutside: () {
        setState(() => _binOpen = false);
      },
    );
  }
}
