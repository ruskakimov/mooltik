import 'package:flutter/material.dart';

class TopDrawer extends StatefulWidget {
  TopDrawer({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _TopDrawerState createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: EaselDrawerClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.child,
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 40,
                width: 40,
                child: Icon(Icons.keyboard_arrow_up),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EaselDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final buttonHeight = 40.0;
    final buttonWidth = 40.0;
    final radius = 8.0;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..relativeLineTo(0, size.height - buttonHeight)
      // Start of inwards curve.
      ..relativeLineTo(-size.width + buttonWidth + radius, 0)
      ..relativeQuadraticBezierTo(-radius, 0, -radius, radius)
      // Start of outwards curve.
      ..lineTo(buttonWidth, size.height - radius)
      ..relativeQuadraticBezierTo(0, radius, -radius, radius)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
