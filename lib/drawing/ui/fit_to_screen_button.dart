import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:provider/provider.dart';

class FitToScreenButton extends StatelessWidget {
  const FitToScreenButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<EaselModel>().fitToScreen();
      },
      child: Container(
        width: 52,
        height: 44,
        color: Colors.red,
        child: Icon(
          FontAwesomeIcons.expand,
          size: 20,
        ),
      ),
    );
  }
}
