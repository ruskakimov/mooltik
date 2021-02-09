import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/common/ui/app_icon_button.dart';
import 'package:mooltik/common/ui/popup_with_arrow.dart';
import 'package:mooltik/common/ui/surface.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Row(
        children: [
          _Logo(),
          Spacer(),
          _TrashButton(),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _TrashButton extends StatelessWidget {
  const _TrashButton({
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

class _Logo extends StatelessWidget {
  const _Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: Theme.of(context).colorScheme.primary,
      child: Image.asset('assets/logo_foreground.png', fit: BoxFit.cover),
    );
  }
}
