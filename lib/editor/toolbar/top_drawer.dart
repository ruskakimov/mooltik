import 'package:flutter/material.dart';

const innerBorderRadius = 16.0;
const outerBorderRadius = 16.0;

class TopDrawer extends StatefulWidget {
  TopDrawer({
    Key key,
    this.height,
    this.child,
  })  : assert(height != null),
        assert(child != null),
        super(key: key);

  final double height;
  final Widget child;

  @override
  _TopDrawerState createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, open ? 0 : -widget.height),
      child: CustomPaint(
        painter: _ClipShadowShadowPainter(
          clipper: _EaselDrawerClipper(),
          shadow: Shadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ),
        child: _buildDrawerBody(),
      ),
    );
  }

  ClipPath _buildDrawerBody() {
    return ClipPath(
      clipper: _EaselDrawerClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.blueGrey[900],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: widget.height,
              child: widget.child,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: _DrawerArrow(
                up: open,
                onTap: _toggleDrawer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDrawer() {
    setState(() {
      open = !open;
    });
  }
}

class _DrawerArrow extends StatelessWidget {
  const _DrawerArrow({
    Key key,
    this.up,
    this.onTap,
  }) : super(key: key);

  final bool up;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Icon(
          up ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _EaselDrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final buttonHeight = 40.0;
    final buttonWidth = 40.0;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..relativeLineTo(0, size.height - buttonHeight)
      // Start of inwards curve.
      ..relativeLineTo(-size.width + buttonWidth + innerBorderRadius, 0)
      ..relativeQuadraticBezierTo(
          -innerBorderRadius, 0, -innerBorderRadius, innerBorderRadius)
      // Start of outwards curve.
      ..lineTo(buttonWidth, size.height - outerBorderRadius)
      ..relativeQuadraticBezierTo(
          0, outerBorderRadius, -outerBorderRadius, outerBorderRadius)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
