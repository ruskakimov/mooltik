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

class _TopDrawerState extends State<TopDrawer>
    with SingleTickerProviderStateMixin {
  bool open = true;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
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
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -widget.height * _animation.value),
          child: child,
        );
      },
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
            Row(
              children: [
                _DrawerArrow(
                  up: open,
                  onTap: _toggleDrawer,
                ),
                Spacer(),
                _DrawerIconButton(
                  icon: Icons.undo,
                ),
                _DrawerIconButton(
                  icon: Icons.redo,
                ),
              ],
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
    if (open) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
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
    return _DrawerIconButton(
      icon: up ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      onTap: onTap,
    );
  }
}

class _DrawerIconButton extends StatelessWidget {
  const _DrawerIconButton({
    Key key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
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
          icon,
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
      ..lineTo(size.width, size.height)
      // Start of outwards curve.
      ..lineTo(size.width - buttonWidth * 2 + outerBorderRadius, size.height)
      ..relativeQuadraticBezierTo(
          -outerBorderRadius, 0, -outerBorderRadius, -outerBorderRadius)
      // Start of inwards curve.
      ..lineTo(size.width - buttonWidth * 2,
          size.height - buttonHeight + innerBorderRadius)
      ..relativeQuadraticBezierTo(
          0, -innerBorderRadius, -innerBorderRadius, -innerBorderRadius)
      // Start of inwards curve.
      ..lineTo(buttonWidth + innerBorderRadius, size.height - buttonHeight)
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
