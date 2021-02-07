import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class PopupEntry extends StatelessWidget {
  const PopupEntry({
    Key key,
    @required this.visible,
    @required this.popup,
    @required this.child,
    this.popupAnchor = Alignment.topCenter,
    this.onTapOutside,
  }) : super(key: key);

  final bool visible;
  final Widget popup;
  final Widget child;
  final Alignment popupAnchor;
  final VoidCallback onTapOutside;

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: visible,
      portal: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          onTapOutside?.call();
        },
      ),
      child: PortalEntry(
        visible: visible,
        portal: popup,
        portalAnchor: popupAnchor,
        child: IgnorePointer(
          ignoring: visible,
          child: child,
        ),
        childAnchor: Alignment.bottomCenter.add(Alignment(0, 0.2)),
      ),
    );
  }
}
