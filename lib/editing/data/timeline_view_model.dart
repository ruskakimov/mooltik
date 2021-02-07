import 'package:flutter/material.dart';
import 'package:mooltik/editing/data/convert.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/frame_sliver.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    TimelineModel timeline,
  }) : _timeline = timeline;

  final TimelineModel _timeline;

  double get msPerPx => _msPerPx;
  double _msPerPx = 10;
  double _prevMsPerPx = 10;
  double _scaleOffset;
  Offset _prevFocalPoint;

  double get timelineWidth => durationToPx(_timeline.totalDuration, _msPerPx);

  void onScaleStart(ScaleStartDetails details) {
    _prevMsPerPx = _msPerPx;
    _prevFocalPoint = details.localFocalPoint;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    _scaleOffset ??= 1 - details.scale;
    _msPerPx = _prevMsPerPx / (details.scale + _scaleOffset);

    final diff = (details.localFocalPoint - _prevFocalPoint);
    _timeline.scrub(-diff.dx / timelineWidth);
    _highlightedFrameIndex = null;

    _prevFocalPoint = details.localFocalPoint;

    notifyListeners();
  }

  void onScaleEnd(ScaleEndDetails details) {
    _scaleOffset = null;
  }

  void onTapUp(TapUpDetails details) {
    _highlightedFrameIndex = _getFrameIndexUnderPosition(details.localPosition);

    // Scroll to selected frame.
    if (_highlightedFrameIndex != null) {
      _timeline.seekTo(timeFromX(details.localPosition.dx));
    }

    notifyListeners();
  }

  int _getFrameIndexUnderPosition(Offset position) {
    // Tapped outside of frame y range.
    if (position.dy < frameSliverTop || position.dy > frameSliverBottom)
      return null;

    // TODO: Reuse slivers used for painting
    for (final sliver in getVisibleFrameSlivers()) {
      if (position.dx > sliver.startX && position.dx < sliver.endX) {
        return sliver.frameIndex;
      }
    }
    return null;
  }

  /// Size of the timeline view.
  /// Update before painting or gesture detection.
  Size size = Size.zero;

  bool get showFrameMenu => _highlightedFrameIndex != null;

  int get highlightedFrameIndex => _highlightedFrameIndex;
  int _highlightedFrameIndex;

  double get _midX => size.width / 2;

  double get sliverHeight => (size.height - 24) / 2;

  double get frameSliverTop => 8;
  double get frameSliverBottom => frameSliverTop + sliverHeight;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - _timeline.playheadPosition, _msPerPx);

  Duration timeFromX(double x) =>
      _timeline.playheadPosition + pxToDuration(x - _midX, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, _msPerPx);

  FrameSliver getSelectedFrameSliver() {
    final double selectedFrameStartX =
        xFromTime(_timeline.selectedFrameStartTime);
    final double selectedFrameWidth =
        widthFromDuration(_timeline.selectedFrame.duration);
    return FrameSliver(
      startX: selectedFrameStartX,
      endX: selectedFrameStartX + selectedFrameWidth,
      thumbnail: _timeline.selectedFrame.snapshot,
      frameIndex: _timeline.selectedFrameIndex,
    );
  }

  List<FrameSliver> getVisibleFrameSlivers() {
    final List<FrameSliver> slivers = [getSelectedFrameSliver()];

    // Fill with slivers on left side.
    for (int i = _timeline.selectedFrameIndex - 1;
        i >= 0 && slivers.first.startX > 0;
        i--) {
      slivers.insert(
        0,
        FrameSliver(
          startX: slivers.first.startX -
              widthFromDuration(_timeline.frames[i].duration),
          endX: slivers.first.startX,
          thumbnail: _timeline.frames[i].snapshot,
          frameIndex: i,
        ),
      );
    }

    // Fill with slivers on right side.
    for (int i = _timeline.selectedFrameIndex + 1;
        i < _timeline.frames.length && slivers.last.endX < size.width;
        i++) {
      slivers.add(FrameSliver(
        startX: slivers.last.endX,
        endX:
            slivers.last.endX + widthFromDuration(_timeline.frames[i].duration),
        thumbnail: _timeline.frames[i].snapshot,
        frameIndex: i,
      ));
    }
    return slivers;
  }

  /*
    Frame menu methods:
  */

  void closeFrameMenu() {
    _highlightedFrameIndex = null;
    notifyListeners();
  }

  bool get canDeleteHighlighted => _timeline.frames.length > 1;

  void deleteSelected() {
    if (_highlightedFrameIndex == null) return;
    if (!canDeleteHighlighted) return;
    _timeline.deleteFrameAt(_highlightedFrameIndex);
    _highlightedFrameIndex = null;
    notifyListeners();
  }

  void duplicateSelected() {
    if (_highlightedFrameIndex == null) return;
    _timeline.duplicateFrameAt(_highlightedFrameIndex);
    _highlightedFrameIndex = null;
    notifyListeners();
  }

  void onDurationHandleDragUpdate(double x) {
    final newDuration = timeFromX(x) - _timeline.selectedFrameStartTime;
    _timeline.changeSelectedFrameDuration(newDuration);
  }
}
