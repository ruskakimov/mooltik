import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/editing/data/convert.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/time_label.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/frame_sliver.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _msPerPxKey = 'timeline_view_ms_per_px';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    @required TimelineModel timeline,
    @required SharedPreferences sharedPreferences,
  })  : _timeline = timeline,
        _preferences = sharedPreferences,
        _msPerPx = sharedPreferences.getDouble(_msPerPxKey) ?? 10 {
    _prevMsPerPx = _msPerPx;
  }

  SharedPreferences _preferences;
  final TimelineModel _timeline;

  double get msPerPx => _msPerPx;
  double _msPerPx;
  double _prevMsPerPx;
  double _scaleOffset;
  Offset _prevFocalPoint;

  double get timelineWidth => durationToPx(_timeline.totalDuration, _msPerPx);

  void onScaleStart(ScaleStartDetails details) {
    _prevMsPerPx = _msPerPx;
    _prevFocalPoint = details.localFocalPoint;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    _scaleOffset ??= 1 - details.scale;
    _setScale(_prevMsPerPx / (details.scale + _scaleOffset));

    final diff = (details.localFocalPoint - _prevFocalPoint);
    final timeDiff = pxToDuration(-diff.dx, _msPerPx);
    _timeline.scrub(timeDiff);

    closeFrameMenu();

    _prevFocalPoint = details.localFocalPoint;

    notifyListeners();
  }

  void _setScale(double newMsPerPx) {
    _msPerPx = newMsPerPx.clamp(1.0, 100.0);
    _preferences.setDouble(_msPerPxKey, _msPerPx);
  }

  void onScaleEnd(ScaleEndDetails details) {
    _scaleOffset = null;
  }

  void onTapUp(TapUpDetails details) {
    _selectedFrameIndex = _getFrameIndexUnderPosition(details.localPosition);
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

  bool get showFrameMenu => _selectedFrameIndex != null;

  int get selectedFrameIndex => _selectedFrameIndex;
  int _selectedFrameIndex;

  Duration get _selectedFrameDuration =>
      _timeline.frameSeq[_selectedFrameIndex].duration;

  String get selectedFrameDurationLabel =>
      durationToLabel(_selectedFrameDuration);

  double get _midX => size.width / 2;

  double get sliverHeight => min((size.height - 24) / 2, 80);

  double get frameSliverTop => 8;
  double get frameSliverBottom => frameSliverTop + sliverHeight;
  double get frameSliverMid => (frameSliverTop + frameSliverBottom) / 2;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - _timeline.playheadPosition, _msPerPx);

  Duration timeFromX(double x) =>
      _timeline.playheadPosition + pxToDuration(x - _midX, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, _msPerPx);

  FrameSliver getCurrentFrameSliver() {
    final double currentFrameStartX =
        xFromTime(_timeline.currentFrameStartTime);
    final double currentFrameWidth =
        widthFromDuration(_timeline.currentFrame.duration);
    return FrameSliver(
      startX: currentFrameStartX,
      endX: currentFrameStartX + currentFrameWidth,
      thumbnail: _timeline.currentFrame.snapshot,
      frameIndex: _timeline.currentFrameIndex,
    );
  }

  List<FrameSliver> getVisibleFrameSlivers() {
    final List<FrameSliver> slivers = [getCurrentFrameSliver()];

    // Fill with slivers on left side.
    for (int i = _timeline.currentFrameIndex - 1;
        i >= 0 && slivers.first.startX > 0;
        i--) {
      slivers.insert(
        0,
        FrameSliver(
          startX: slivers.first.startX -
              widthFromDuration(_timeline.frameSeq[i].duration),
          endX: slivers.first.startX,
          thumbnail: _timeline.frameSeq[i].snapshot,
          frameIndex: i,
        ),
      );
    }

    // Fill with slivers on right side.
    for (int i = _timeline.currentFrameIndex + 1;
        i < _timeline.frameSeq.length && slivers.last.endX < size.width;
        i++) {
      slivers.add(FrameSliver(
        startX: slivers.last.endX,
        endX: slivers.last.endX +
            widthFromDuration(_timeline.frameSeq[i].duration),
        thumbnail: _timeline.frameSeq[i].snapshot,
        frameIndex: i,
      ));
    }
    return slivers;
  }

  /*
    Frame menu methods:
  */

  void closeFrameMenu() {
    _selectedFrameIndex = null;
    notifyListeners();
  }

  bool get canDeleteSelected => _timeline.frameSeq.length > 1;

  void deleteSelected() {
    if (_selectedFrameIndex == null) return;
    if (!canDeleteSelected) return;
    _timeline.deleteFrameAt(_selectedFrameIndex);
    closeFrameMenu();
    notifyListeners();
  }

  void duplicateSelected() {
    if (_selectedFrameIndex == null) return;
    _timeline.duplicateFrameAt(_selectedFrameIndex);
    closeFrameMenu();
    notifyListeners();
  }

  /// Handle start time drag handle's new [updatedTimestamp].
  void onStartTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDuration(updatedTimestamp);

    final newSelectedDuration =
        _timeline.frameSeq.endTimeOf(_selectedFrameIndex) - updatedTimestamp;
    final diff = newSelectedDuration - _selectedFrameDuration;
    final newPrevDuration =
        _timeline.frameSeq[_selectedFrameIndex - 1].duration - diff;

    if (newPrevDuration < TimeSpan.singleFrameDuration) return;

    _timeline.changeFrameDurationAt(
      _selectedFrameIndex - 1,
      newPrevDuration,
    );
    _timeline.changeFrameDurationAt(_selectedFrameIndex, newSelectedDuration);
    notifyListeners();
  }

  /// Handle end time drag handle's new [updatedTimestamp].
  void onEndTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDuration(updatedTimestamp);

    final newDuration =
        updatedTimestamp - _timeline.frameSeq.startTimeOf(_selectedFrameIndex);
    _timeline.changeFrameDurationAt(_selectedFrameIndex, newDuration);
    notifyListeners();
  }

  /// Whether timestamp is close enough to playhead for it to snap to it.
  bool _shouldSnapToPlayhead(Duration timestamp) {
    final diff = (_timeline.playheadPosition - timestamp).abs();
    final pxDiff = durationToPx(diff, _msPerPx);
    return pxDiff <= 12;
  }
}
