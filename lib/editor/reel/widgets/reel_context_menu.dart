import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../reel_model.dart';

const double menuWidth = 64.0;

class ReelContextMenu extends StatelessWidget {
  const ReelContextMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();

    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        disabledColor:
            Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
        dividerColor:
            Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
      ),
      child: Transform.translate(
        offset: Offset(8, 0),
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          elevation: 5,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: menuWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      size: 18,
                    ),
                    onPressed: reel.canDeleteSelectedFrame
                        ? reel.deleteSelectedFrame
                        : null,
                  ),
                  Divider(),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 20,
                    ),
                    onPressed: reel.copySelectedFrame,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.paste,
                      size: 20,
                    ),
                    onPressed: reel.pasteInSelectedFrame,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
