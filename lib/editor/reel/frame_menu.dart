import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'reel_model.dart';
import 'reel_drawer.dart';

const double menuWidth = 120.0;

class FrameMenu extends StatelessWidget {
  const FrameMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reel = context.watch<ReelModel>();
    final frame = reel.selectedFrame;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 150),
      curve: Curves.easeOut,
      left: reel.menuOpen ? drawerWidth : -menuWidth + drawerWidth,
      child: Container(
        width: menuWidth,
        height: thumbnailHeight,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Material(
              color: Colors.amber,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.grey[850],
                  size: 22,
                ),
                onPressed: () {
                  frame.duration++;
                },
              ),
            ),
            Material(
              color: Colors.amber,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.minus,
                  color: Colors.grey[850],
                  size: 22,
                ),
                onPressed: () {
                  frame.duration--;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
