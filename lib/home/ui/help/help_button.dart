import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/home/ui/help/help_contents.dart';
import 'package:mooltik/common/ui/open_side_sheet.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(MdiIcons.help),
      onPressed: () {
        openSideSheet(
          context: context,
          builder: (context) => HelpContents(),
        );
      },
    );
  }
}
