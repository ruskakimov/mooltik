import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

const _popupAnimationDuration = Duration(milliseconds: 150);

class PopupEntry extends StatefulWidget {
  const PopupEntry({
    Key? key,
    required this.visible,
    required this.popup,
    required this.child,
    this.popupAnchor = Alignment.topCenter,
    this.childAnchor = const Alignment(0, 1.2),
    this.onTapOutside,
    this.onDragOutside,
  }) : super(key: key);

  final bool visible;
  final Widget popup;
  final Widget child;
  final Alignment popupAnchor;
  final Alignment childAnchor;
  final VoidCallback? onTapOutside;
  final VoidCallback? onDragOutside;

  @override
  _PopupEntryState createState() => _PopupEntryState();
}

class _PopupEntryState extends State<PopupEntry> {
  Widget? _popup;

  @override
  void didUpdateWidget(covariant PopupEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Don't update popup configuration when popup is fading out.
    if (widget.visible) {
      _popup = widget.popup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: widget.visible,
      portal: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) {
          widget.onTapOutside?.call();
        },
        onPointerMove: (_) {
          widget.onDragOutside?.call();
        },
      ),
      child: PortalEntry(
        visible: widget.visible,
        closeDuration: _popupAnimationDuration,
        portal: TweenAnimationBuilder<double>(
          duration: _popupAnimationDuration,
          tween: Tween(begin: 0, end: widget.visible ? 1 : 0),
          builder: (context, progress, child) => Opacity(
            opacity: progress,
            child: child,
          ),
          child: _popup,
        ),
        portalAnchor: widget.popupAnchor,
        child: IgnorePointer(
          ignoring: widget.visible,
          child: widget.child,
        ),
        childAnchor: widget.childAnchor,
      ),
    );
  }
}
