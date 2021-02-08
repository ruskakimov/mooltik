import 'package:flutter/material.dart';

const double _triangleWidth = 24;
const double _triangleHeight = 14;
const double _triangleBorderRadius = 4;

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
          top: -_triangleHeight,
          left: arrowOffset == null
              ? (width - _triangleWidth) / 2
              : arrowOffset - _triangleWidth / 2,
          child: RotatedBox(
            quarterTurns: _triangleQuarterTurns(),
            child: _Triangle(),
          ),
        ),
      ],
    );
  }

  int _triangleQuarterTurns() {
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

class _Triangle extends StatelessWidget {
  const _Triangle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: _triangleWidth,
        height: _triangleHeight,
        color: Theme.of(context).colorScheme.secondary,
      ),
      clipper: _TriangleClipper(),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final roundingLeftX = w / 2 - _triangleBorderRadius;
    final roundingRightX = w / 2 + _triangleBorderRadius;
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
