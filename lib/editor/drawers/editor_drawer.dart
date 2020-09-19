import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drawer_icon_button.dart';

const innerBorderRadius = 16.0;
const outerBorderRadius = 16.0;

class EditorDrawer extends StatefulWidget {
  EditorDrawer({
    Key key,
    this.height,
    this.body,
    this.quickAccessButtons,
  })  : assert(height != null),
        assert(body != null),
        super(key: key);

  final double height;
  final Widget body;
  final List<DrawerIconButton> quickAccessButtons;

  @override
  _EditorDrawerState createState() => _EditorDrawerState();
}

class _EditorDrawerState extends State<EditorDrawer>
    with SingleTickerProviderStateMixin {
  bool open = true;
  AnimationController _controller;
  Animation _animation;
  CustomClipper _clipper;

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
    _clipper = _DrawerClipper(
      buttonHeight: 48,
      buttonWidth: 48,
      rightButtonCount: widget.quickAccessButtons?.length ?? 0,
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
        painter: _ClippedShadowPainter(
          clipper: _clipper,
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
      clipper: _clipper,
      child: Container(
        width: double.infinity,
        color: Colors.blueGrey[900],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: widget.height,
              child: widget.body,
            ),
            Row(
              children: [
                DrawerIconButton(
                  icon: open
                      ? FontAwesomeIcons.chevronUp
                      : FontAwesomeIcons.chevronDown,
                  onTap: _toggleDrawer,
                ),
                Spacer(),
                if (widget.quickAccessButtons != null)
                  ...widget.quickAccessButtons,
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

class _DrawerClipper extends CustomClipper<Path> {
  _DrawerClipper({
    @required this.buttonHeight,
    @required this.buttonWidth,
    this.rightButtonCount = 0,
  }) : super();

  final double buttonHeight;
  final double buttonWidth;
  final int rightButtonCount;

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      // Start of outwards curve.
      ..lineTo(size.width - buttonWidth * rightButtonCount + outerBorderRadius,
          size.height)
      ..relativeQuadraticBezierTo(
          -outerBorderRadius, 0, -outerBorderRadius, -outerBorderRadius)
      // Start of inwards curve.
      ..lineTo(size.width - buttonWidth * rightButtonCount,
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

class _ClippedShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClippedShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
