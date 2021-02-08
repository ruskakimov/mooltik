import 'package:flutter/material.dart';

const double _arrowWidth = 24;
const double _arrowHeight = 14;
const double _arrowBorderRadius = 4;

enum ArrowSide {
  top,
  left,
  right,
  bottom,
}

class PopupWithArrow extends StatelessWidget {
  const PopupWithArrow({
    Key key,
    @required this.width,
    this.arrowOffset,
    this.child,
    this.arrowSide = ArrowSide.top,
  }) : super(key: key);

  final double width;
  final double arrowOffset;
  final Widget child;
  final ArrowSide arrowSide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadiusDirectional.circular(8),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
        Positioned(
          top: -_arrowHeight,
          left: arrowOffset == null
              ? (width - _arrowWidth) / 2
              : arrowOffset - _arrowWidth / 2,
          child: RotatedBox(
            quarterTurns: _arrowQuarterTurns(),
            child: _Arrow(),
          ),
        ),
      ],
    );
  }

  int _arrowQuarterTurns() {
    switch (arrowSide) {
      case ArrowSide.top:
        return 0;
      case ArrowSide.right:
        return 1;
      case ArrowSide.bottom:
        return 2;
      case ArrowSide.left:
        return 3;
      default:
        return 0;
    }
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: _arrowWidth,
        height: _arrowHeight,
        color: Theme.of(context).colorScheme.secondary,
      ),
      clipper: _ArrowClipper(),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final roundingLeftX = w / 2 - _arrowBorderRadius;
    final roundingRightX = w / 2 + _arrowBorderRadius;
    final roundingY = h - h * roundingLeftX / (w / 2);

    return Path()
      ..moveTo(0, h)
      ..lineTo(roundingLeftX, roundingY)
      ..quadraticBezierTo(w / 2, 0, roundingRightX, roundingY)
      ..lineTo(w, h)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
