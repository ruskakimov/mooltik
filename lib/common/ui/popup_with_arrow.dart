import 'package:flutter/material.dart';

const double _arrowWidth = 24;
const double _arrowHeight = 14;
const double _arrowBorderRadius = 4;

/// The side of the popup on which arrow is put.
enum ArrowSide {
  top,
  left,
  right,
  bottom,
}

/// Arrow position on popup side.
enum ArrowPosition {
  /// Left on horizontal side and top on vertical side.
  start,

  /// Middle of selected popup side.
  middle,

  /// Right on horizontal side and bottom on vertical side.
  end,
}

class PopupWithArrow extends StatelessWidget {
  const PopupWithArrow({
    Key key,
    @required this.width,
    this.child,
    this.arrowSide = ArrowSide.top,
    this.arrowPosition = ArrowPosition.middle,
  }) : super(key: key);

  final double width;
  final Widget child;
  final ArrowSide arrowSide;
  final ArrowPosition arrowPosition;

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
          top: arrowSide == ArrowSide.top ? _arrowSideOffset : null,
          left: arrowSide == ArrowSide.left
              ? _arrowSideOffset
              : arrowSide == ArrowSide.right
                  ? null
                  : _horizontalSideLeftOffset,
          right: arrowSide == ArrowSide.right ? _arrowSideOffset : null,
          bottom: arrowSide == ArrowSide.bottom ? _arrowSideOffset : null,
          child: RotatedBox(
            quarterTurns: _arrowQuarterTurns,
            child: _Arrow(),
          ),
        ),
      ],
    );
  }

  double get _arrowSideOffset => -_arrowHeight + 0.5;

  double get _horizontalSideLeftOffset {
    switch (arrowPosition) {
      case ArrowPosition.start:
        return _arrowWidth;
      case ArrowPosition.end:
        return width - _arrowWidth * 2;
      case ArrowPosition.middle:
      default:
        return (width - _arrowWidth) / 2;
    }
  }

  int get _arrowQuarterTurns {
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
