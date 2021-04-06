import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/project/scene_model.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame_model.dart';
import 'package:mooltik/editing/data/convert.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/time_label.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/image_sliver.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _msPerPxKey = 'timeline_view_ms_per_px';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    @required TimelineModel timeline,
    @required SharedPreferences sharedPreferences,
    @required this.createNewFrame,
  })  : _timeline = timeline,
        _preferences = sharedPreferences,
        _msPerPx = sharedPreferences.getDouble(_msPerPxKey) ?? 10 {
    _prevMsPerPx = _msPerPx;
  }

  SharedPreferences _preferences;
  final TimelineModel _timeline;
  final CreateNewFrame createNewFrame;

  bool get isEditingScene => _sceneEdit;
  bool _sceneEdit = false;

  void editScene() {
    _sceneEdit = true;
    notifyListeners();
  }

  void finishSceneEdit() {
    _sceneEdit = false;
    notifyListeners();
  }

  Sequence<TimeSpan> get imageSpans =>
      _sceneEdit ? _timeline.currentScene.frameSeq : _timeline.sceneSeq;

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

    closeSliverMenu();

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
    _selectedSliverIndex = _getIndexUnderPosition(details.localPosition);
    notifyListeners();
  }

  int _getIndexUnderPosition(Offset position) {
    if (position.dy < imageSliverTop || position.dy > imageSliverBottom)
      return null;

    // TODO: Reuse slivers used for painting
    for (final sliver in getVisibleImageSlivers()) {
      if (position.dx > sliver.startX && position.dx < sliver.endX) {
        return sliver.index;
      }
    }
    return null;
  }

  /// Size of the timeline view.
  /// Update before painting or gesture detection.
  Size size = Size.zero;

  bool get showSliverMenu => _selectedSliverIndex != null;

  int get selectedSliverIndex => _selectedSliverIndex;
  int _selectedSliverIndex;

  Duration get _selectedSliverDuration =>
      imageSpans[_selectedSliverIndex].duration;

  String get selectedSliverDurationLabel =>
      durationToLabel(_selectedSliverDuration);

  double get _midX => size.width / 2;

  double get sliverHeight => min((size.height - 24) / 2, 80);

  double get imageSliverTop => 8;
  double get imageSliverBottom => imageSliverTop + sliverHeight;
  double get imageSliverMid => (imageSliverTop + imageSliverBottom) / 2;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - _timeline.playheadPosition, _msPerPx);

  Duration timeFromX(double x) =>
      _timeline.playheadPosition + pxToDuration(x - _midX, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, _msPerPx);

  ui.Image _getImageSpanThumbnail(int index) {
    if (isEditingScene) {
      return (imageSpans as Sequence<FrameModel>)[index].snapshot;
    } else {
      return (imageSpans as Sequence<SceneModel>)[index].frameSeq[0].snapshot;
    }
  }

  ImageSliver getCurrentImageSliver() {
    return ImageSliver(
      startX: xFromTime(imageSpans.currentSpanStart),
      endX: xFromTime(imageSpans.currentSpanEnd),
      thumbnail: _getImageSpanThumbnail(imageSpans.currentIndex),
      index: imageSpans.currentIndex,
    );
  }

  List<ImageSliver> getVisibleImageSlivers() {
    final List<ImageSliver> slivers = [getCurrentImageSliver()];

    // Fill with slivers on left side.
    for (int i = imageSpans.currentIndex - 1;
        i >= 0 && slivers.first.startX > 0;
        i--) {
      slivers.insert(
        0,
        ImageSliver(
          startX:
              slivers.first.startX - widthFromDuration(imageSpans[i].duration),
          endX: slivers.first.startX,
          thumbnail: _getImageSpanThumbnail(i),
          index: i,
        ),
      );
    }

    // Fill with slivers on right side.
    for (int i = imageSpans.currentIndex + 1;
        i < imageSpans.length && slivers.last.endX < size.width;
        i++) {
      slivers.add(ImageSliver(
        startX: slivers.last.endX,
        endX: slivers.last.endX + widthFromDuration(imageSpans[i].duration),
        thumbnail: _getImageSpanThumbnail(i),
        index: i,
      ));
    }
    return slivers;
  }

  /*
    Sliver menu methods:
  */

  void closeSliverMenu() {
    _selectedSliverIndex = null;
    notifyListeners();
  }

  bool get canDeleteSelected => imageSpans.length > 1;

  void deleteSelected() {
    if (_selectedSliverIndex == null) return;
    if (!canDeleteSelected) return;
    imageSpans.removeAt(_selectedSliverIndex);
    closeSliverMenu();
    notifyListeners();
  }

  Future<void> duplicateSelected() async {
    if (_selectedSliverIndex == null) return;
    if (isEditingScene) {
      await _duplicateSelectedFrame();
    } else {
      await _duplicateSelectedScene();
    }
    closeSliverMenu();
    notifyListeners();
  }

  Future<void> _duplicateSelectedFrame() async {
    final newFrame = await createNewFrame();
    final duplicate = (imageSpans as Sequence<FrameModel>)[_selectedSliverIndex]
        .copyWith(file: newFrame.file);
    imageSpans.insert(_selectedSliverIndex, duplicate);
  }

  Future<void> _duplicateSelectedScene() async {
    // TODO: Implement scene duplication
  }

  /// Handle start time drag handle's new [updatedTimestamp].
  void onStartTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDuration(updatedTimestamp);

    final newSelectedDuration =
        imageSpans.endTimeOf(_selectedSliverIndex) - updatedTimestamp;
    final diff = newSelectedDuration - _selectedSliverDuration;
    final newPrevDuration =
        imageSpans[_selectedSliverIndex - 1].duration - diff;

    if (newPrevDuration < TimeSpan.singleFrameDuration) return;

    imageSpans.changeSpanDurationAt(_selectedSliverIndex - 1, newPrevDuration);
    imageSpans.changeSpanDurationAt(_selectedSliverIndex, newSelectedDuration);
    notifyListeners();
  }

  /// Handle end time drag handle's new [updatedTimestamp].
  void onEndTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDuration(updatedTimestamp);
    final newDuration =
        updatedTimestamp - imageSpans.startTimeOf(_selectedSliverIndex);

    imageSpans.changeSpanDurationAt(_selectedSliverIndex, newDuration);
    notifyListeners();
  }

  /// Whether timestamp is close enough to playhead for it to snap to it.
  bool _shouldSnapToPlayhead(Duration timestamp) {
    final diff = (_timeline.playheadPosition - timestamp).abs();
    final pxDiff = durationToPx(diff, _msPerPx);
    return pxDiff <= 12;
  }
}
