import 'package:flutter/material.dart';
import 'package:mooltik/common/ui/measure_hack.dart';
import 'package:mooltik/common/ui/popup_entry.dart';

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
enum ArrowSidePosition {
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
    @required this.child,
    this.arrowSide = ArrowSide.top,
    this.arrowPosition = ArrowSidePosition.middle,
    this.color,
  }) : super(key: key);

  final Widget child;
  final ArrowSide arrowSide;
  final ArrowSidePosition arrowPosition;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final arrowAlignment = _arrowAlignment(arrowSide, arrowPosition);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: color ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadiusDirectional.circular(8),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          child: child,
        ),
        Positioned.fill(
          child: Align(
            alignment: arrowAlignment,
            child: Transform.translate(
              offset: _arrowOffset(arrowSide, arrowAlignment),
              child: RotatedBox(
                quarterTurns: _arrowQuarterTurns,
                child: _Arrow(color: color),
              ),
            ),
          ),
        ),
      ],
    );
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
    this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: _arrowWidth,
        height: _arrowHeight,
        color: color ?? Theme.of(context).colorScheme.secondary,
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

Alignment _arrowAlignment(
  ArrowSide arrowSide,
  ArrowSidePosition arrowPosition,
) {
  double _arrowAlignmentX() {
    if (arrowSide == ArrowSide.left) return -1;
    if (arrowSide == ArrowSide.right) return 1;
    if (arrowPosition == ArrowSidePosition.start) return -1;
    if (arrowPosition == ArrowSidePosition.end) return 1;
    return 0;
  }

  double _arrowAlignmentY() {
    if (arrowSide == ArrowSide.top) return -1;
    if (arrowSide == ArrowSide.bottom) return 1;
    if (arrowPosition == ArrowSidePosition.start) return -1;
    if (arrowPosition == ArrowSidePosition.end) return 1;
    return 0;
  }

  return Alignment(_arrowAlignmentX(), _arrowAlignmentY());
}

bool _horizontalArrowSide(ArrowSide arrowSide) =>
    arrowSide == ArrowSide.top || arrowSide == ArrowSide.bottom;

Offset _arrowOffset(
  ArrowSide arrowSide,
  Alignment arrowAlignment,
) {
  // Adjust for sub-pixel gap artifact.
  final h = _arrowHeight - 0.5;
  final w = _arrowWidth;

  if (_horizontalArrowSide(arrowSide)) {
    return Offset(w * -arrowAlignment.x, h * arrowAlignment.y);
  } else {
    return Offset(h * arrowAlignment.x, w * -arrowAlignment.y);
  }
}

class PopupWithArrowEntry extends StatefulWidget {
  const PopupWithArrowEntry({
    Key key,
    @required this.visible,
    @required this.popupBody,
    @required this.child,
    this.arrowSide = ArrowSide.top,
    this.arrowSidePosition = ArrowSidePosition.middle,
    this.arrowAnchor = const Alignment(0, 0.6),
    this.popupColor,
    this.onTapOutside,
    this.onDragOutside,
  }) : super(key: key);

  final bool visible;
  final Widget popupBody;
  final Widget child;
  final ArrowSide arrowSide;
  final ArrowSidePosition arrowSidePosition;
  final Alignment arrowAnchor;
  final Color popupColor;
  final VoidCallback onTapOutside;
  final VoidCallback onDragOutside;

  @override
  _PopupWithArrowEntryState createState() => _PopupWithArrowEntryState();
}

class _PopupWithArrowEntryState extends State<PopupWithArrowEntry> {
  Size _popupSize;

  @override
  Widget build(BuildContext context) {
    var arrowAlignment =
        _arrowAlignment(widget.arrowSide, widget.arrowSidePosition);
    var arrowOffset =
        _arrowOffset(widget.arrowSide, arrowAlignment).scale(-1, -1);

    if (_horizontalArrowSide(widget.arrowSide)) {
      arrowOffset += Offset(_arrowWidth / 2 * arrowAlignment.x, 0);
    } else {
      arrowOffset += Offset(0, _arrowWidth / 2 * arrowAlignment.y);
    }

    // This is a hack to move tappable area with popup.
    // Previously a transform was used, but transform doesn't move tappable area.
    if (_popupSize != null) {
      arrowAlignment = arrowAlignment.add(Alignment(
        -arrowOffset.dx / _popupSize.width * 2,
        -arrowOffset.dy / _popupSize.height * 2,
      ));
    }

    return PopupEntry(
      visible: widget.visible,
      childAnchor: widget.arrowAnchor,
      popupAnchor: arrowAlignment,
      popup: MeasurableWidget(
        onChange: (Size size) => setState(() => _popupSize = size),
        child: PopupWithArrow(
          arrowSide: widget.arrowSide,
          arrowPosition: widget.arrowSidePosition,
          child: widget.popupBody,
          color: widget.popupColor,
        ),
      ),
      child: widget.child,
      onTapOutside: widget.onTapOutside,
      onDragOutside: widget.onDragOutside,
    );
  }
}
