import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mooltik/editor/drawers/drawer_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:mooltik/editor/timeline/timeline_model.dart';
import 'package:mooltik/editor/timeline/timeline_painter.dart';
import 'package:vibration/vibration.dart';

class Timeline extends StatefulWidget {
  const Timeline({
    Key key,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _prevOffset;

  final frameWidth = 24.0;
  int _animationFrames = 1;

  bool get playing => context.read<TimelineModel>().playing;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
    )..addListener(() {
        if (_prevOffset != null) {
          final prevFrameNumber = _frameNumber(_prevOffset);
          final newFrameNumber = _frameNumber(_controller.value);

          if (newFrameNumber != prevFrameNumber) {
            if (!playing) Vibration.vibrate(duration: 10);
            context.read<TimelineModel>().selectFrame(newFrameNumber);
          }
        }
        _prevOffset = _controller.value;
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && playing) {
        _playFromStart();
      }
    });
  }

  void _playFromStart() {
    _controller.reset();
    _controller.animateTo(
      _animationFrames * frameWidth,
      duration: Duration(milliseconds: (1000 / 24 * _animationFrames).floor()),
    );
  }

  void _snapToFrameStart() {
    final snapTarget = _notchPositionBefore(_controller.value);
    _controller.animateTo(
      snapTarget,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  int _frameNumber(double offset) => offset ~/ frameWidth + 1;

  double _notchPositionBefore(double offset) => offset - offset % frameWidth;

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<TimelineModel>();
    _animationFrames = timeline.animationDuration;

    return Column(
      children: [
        SizedBox(
          height: 56,
          child: _buildTimelineBar(),
        ),
        Expanded(
          child: _buildTimelineViewport(timeline),
        ),
      ],
    );
  }

  SizedBox _buildTimelineViewport(TimelineModel timeline) {
    return SizedBox.expand(
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _controller.value -= details.primaryDelta;
        },
        onHorizontalDragEnd: (details) {
          _snapToFrameStart();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              child: ColoredBox(
                color: Colors.blueGrey[900],
              ),
              foregroundPainter: TimelinePainter(
                frameWidth: frameWidth,
                offset: _controller.value,
                emptyKeyframes: [1],
                keyframes: timeline.keyframes.map((f) => f.number).toList(),
                animationDuration: timeline.animationDuration,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineBar() {
    return Builder(builder: (context) {
      final timeline = context.watch<TimelineModel>();
      return Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              DrawerIconButton(
                icon: timeline.playing
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
                onTap: () {
                  timeline.togglePlay();
                  if (timeline.playing) {
                    _playFromStart();
                  } else if (!timeline.playing) {
                    _controller.stop();
                    _snapToFrameStart();
                  }
                },
              ),
              DrawerIconButton(icon: FontAwesomeIcons.layerGroup),
              Spacer(),
              SizedBox(
                width: 96,
                child: Text(
                  '${timeline.selectedFrameNumber} F',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          DrawerIconButton(
            icon: FontAwesomeIcons.trashAlt,
            onTap: timeline.selectedCanBeDeleted
                ? timeline.deleteSelectedKeyframe
                : null,
          ),
        ],
      );
    });
  }
}
