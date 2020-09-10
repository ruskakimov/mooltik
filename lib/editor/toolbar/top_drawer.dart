import 'package:flutter/material.dart';

class TopDrawer extends StatefulWidget {
  TopDrawer({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _TopDrawerState createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, open ? 0 : -52),
      child: CustomPaint(
        painter: _ClipShadowShadowPainter(
          clipper: _EaselDrawerClipper(),
          shadow: Shadow(
            color: Colors.black26,
            blurRadius: 8,
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
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.child,
            Align(
              alignment: Alignment.centerLeft,
              child: _DrawerArrow(
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
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

class _EaselDrawerClipper extends CustomClipper<Path> {
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
