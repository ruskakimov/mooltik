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
    final isFittedToScreen = context.select<EaselModel, bool>(
      (easel) => easel.isFittedToScreen,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isFittedToScreen
          ? null
          : () => context.read<EaselModel>().fitToScreen(),
      child: SizedBox(
        width: 52,
        height: 44,
        child: Opacity(
          opacity: isFittedToScreen ? 0.5 : 1,
          child: SvgPicture.asset(
            'assets/icons/fa-solid_expand.svg',
            fit: BoxFit.none,
          ),
        ),
      ),
    );
  }
}
