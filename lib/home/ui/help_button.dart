import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mooltik/common/ui/sheet_title.dart';
import 'package:mooltik/home/data/gallery_model.dart';
import 'package:provider/provider.dart';
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
        final gallery = context.read<GalleryModel>();

        openSideSheet(
          context: context,
          builder: (context) => ChangeNotifierProvider.value(
            value: gallery,
            child: SheetTitle('Tutorials'),
          ),
        );
      },
    );
  }
}
