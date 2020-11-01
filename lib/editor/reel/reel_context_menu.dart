import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'reel_model.dart';

const double menuWidth = 64.0;

class ReelContextMenu extends StatelessWidget {
  const ReelContextMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();
    final frame = reel.selectedFrame;

    return Transform.translate(
      offset: Offset(8, 0),
      child: Material(
        color: Colors.grey[800],
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: menuWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.plus,
                  size: 18,
                ),
                onPressed: () {
                  frame.duration++;
                },
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.minus,
                  size: 18,
                ),
                onPressed: () {
                  frame.duration--;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
