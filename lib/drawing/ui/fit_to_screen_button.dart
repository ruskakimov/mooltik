import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mooltik/drawing/data/easel_model.dart';
import 'package:provider/provider.dart';

class FitToScreenButton extends StatelessWidget {
  const FitToScreenButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<EaselModel>().fitToScreen();
      },
      child: SizedBox(
        width: 52,
        height: 44,
        child: SvgPicture.asset(
          'assets/fa-solid_expand.svg',
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
