import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TimelineViewButton extends StatelessWidget {
  const TimelineViewButton({
    Key? key,
    required this.showTimelineIcon,
    this.onTap,
  }) : super(key: key);

  final bool showTimelineIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      elevation: 2,
      child: _buildIcon(),
      onPressed: onTap,
    );
  }

  Widget _buildIcon() => SvgPicture.asset(
        showTimelineIcon
            ? 'assets/icons/timeline.svg'
            : 'assets/icons/board.svg',
        fit: BoxFit.none,
        color: Colors.white,
      );
}
