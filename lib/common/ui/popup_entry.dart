import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

const _popupAnimationDuration = Duration(milliseconds: 150);

class PopupEntry extends StatelessWidget {
  const PopupEntry({
    Key key,
    @required this.visible,
    @required this.popup,
    @required this.child,
    this.popupAnchor = Alignment.topCenter,
    this.childAnchor = const Alignment(0, 1.2),
    this.onTapOutside,
  }) : super(key: key);

  final bool visible;
  final Widget popup;
  final Widget child;
  final Alignment popupAnchor;
  final Alignment childAnchor;
  final VoidCallback onTapOutside;

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: visible,
      portal: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) {
          onTapOutside?.call();
        },
      ),
      child: PortalEntry(
        visible: visible,
        closeDuration: _popupAnimationDuration,
        portal: TweenAnimationBuilder<double>(
          duration: _popupAnimationDuration,
          tween: Tween(begin: 0, end: visible ? 1 : 0),
          builder: (context, progress, child) => Opacity(
            opacity: progress,
            child: child,
          ),
          child: popup,
        ),
        portalAnchor: popupAnchor,
        child: IgnorePointer(
          ignoring: visible,
          child: child,
        ),
        childAnchor: childAnchor,
      ),
    );
  }
}
