import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/sound_clip.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/common/data/sequence/time_span.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/editing/data/convert.dart';
import 'package:mooltik/editing/data/timeline_model.dart';
import 'package:mooltik/editing/ui/timeline/actionbar/time_label.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/image_sliver.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sliver.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/sound_sliver.dart';
import 'package:mooltik/editing/ui/timeline/view/sliver/video_sliver.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _msPerPxKey = 'timeline_view_ms_per_px';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({
    @required TimelineModel timeline,
    @required List<SoundClip> soundClips,
    @required SharedPreferences sharedPreferences,
    @required this.createNewFrame,
  })  : _timeline = timeline,
        _soundClips = soundClips ?? [],
        _preferences = sharedPreferences,
        _msPerPx = sharedPreferences?.getDouble(_msPerPxKey) ?? 10 {
    _prevMsPerPx = _msPerPx;
    timeline.addListener(notifyListeners);
  }

  SharedPreferences _preferences;
  final TimelineModel _timeline;
  final List<SoundClip> _soundClips;
  final CreateNewFrame createNewFrame;

  bool get isEditingScene => _sceneEdit;
  bool _sceneEdit = false;

  Sequence<TimeSpan> get imageSpans => _sceneEdit
      ? _timeline.currentScene.layers.first.frameSeq
      : _timeline.sceneSeq;

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
    var timeDiff = pxToDuration(-diff.dx, _msPerPx);
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
    final sliverIndex = _getIndexUnderPosition(details.localPosition);
    selectSliver(sliverIndex);
  }

  /// Selects a given sliver or removes selection if [sliverIndex] is `null`.
  void selectSliver(int sliverIndex) {
    if (_timeline.isPlaying) _timeline.pause();
    _selectedImageSpanIndex = sliverIndex;
    notifyListeners();
  }

  int _getIndexUnderPosition(Offset position) {
    if (position.dy < imageSliverTop || position.dy > imageSliverBottom)
      return null;

    // TODO: Reuse slivers used for painting
    // for (final sliver in getVisibleImageSlivers()) {
    //   if (sliver.area.contains(position)) {
    //     return sliver.index;
    //   }
    // }
    return null;
  }

  /// Size of the timeline view.
  /// Update before painting or gesture detection.
  Size size = Size.zero;

  bool get showSliverMenu => _selectedImageSpanIndex != null;

  bool get showResizeStartHandle =>
      showSliverMenu && _selectedImageSpanIndex != 0;

  bool get showResizeEndHandle => showSliverMenu;

  // TODO: Convert to 2D coordinate (row index & span index)
  int get selectedImageSpanIndex => _selectedImageSpanIndex;
  int _selectedImageSpanIndex;

  TimeSpan get selectedImageSpan => imageSpans[_selectedImageSpanIndex];
  Frame get selectedFrame => selectedImageSpan as Frame;
  Scene get selectedScene => selectedImageSpan as Scene;

  Duration get _selectedSliverDuration => selectedImageSpan.duration;

  String get selectedSliverDurationLabel =>
      durationToLabel(_selectedSliverDuration);

  double get _midX => size.width / 2;

  double get sliverHeight => 56;

  double get sliverGap => 8;

  int get sliverRows =>
      isEditingScene ? _timeline.currentScene.layers.length + 1 : 2;

  double get viewHeight =>
      sliverRows * sliverHeight + (sliverRows + 1) * sliverGap;

  double get imageSliverTop => sliverGap;
  double get imageSliverBottom => imageSliverTop + sliverHeight;
  double get imageSliverMid => (imageSliverTop + imageSliverBottom) / 2;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - _timeline.playheadPosition, _msPerPx);

  Duration timeFromX(double x) =>
      _timeline.playheadPosition + pxToDuration(x - _midX, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, _msPerPx);

  Duration get sceneStart => _timeline.currentSceneStart;

  Duration get sceneEnd => _timeline.currentSceneEnd;

  List<List<Sliver>> getSliverRows() {
    final rows = <List<Sliver>>[];
    double rowTop = sliverGap;

    if (isEditingScene) {
      // getVisibleImageSlivers(_timeline.)
      // ImageSliver(
      //   area: area,
      //   thumbnail: (imageSpan as Frame).snapshot,
      //   index: _isGhostFrame(imageSpanIndex) ? null : imageSpanIndex,
      //   opacity: _isGhostFrame(imageSpanIndex) ? 0.5 : 1,
      // )
      // bool _isGhostFrame(int i) => i >= imageSpans.length
    } else {
      final sceneSeq = _timeline.sceneSeq;
      final sceneRow = sceneSlivers(
        areas: timeSpanAreas(
          timeSpans: sceneSeq.iterable,
          top: rowTop,
          bottom: rowTop + sliverHeight,
        ),
        scenes: sceneSeq.iterable,
      ).toList();

      rows.add(sceneRow);
    }

    rows.add(getVisibleSoundSlivers());

    return rows;
  }

  Iterable<VideoSliver> sceneSlivers({
    @required Iterable<Rect> areas,
    @required Iterable<Scene> scenes,
  }) sync* {
    int index = 0;
    final areaIt = areas.iterator;
    final sceneIt = scenes.iterator;

    while (areaIt.moveNext() && sceneIt.moveNext()) {
      final area = areaIt.current;
      final scene = sceneIt.current;

      yield VideoSliver(
        area: area,
        thumbnailAt: (double x) {
          final position = pxToDuration(x - area.left, msPerPx);
          return scene.imageAt(position);
        },
        index: index,
      );

      index++;
    }
  }

  Iterable<Rect> timeSpanAreas({
    @required Iterable<TimeSpan> timeSpans,
    @required double top,
    @required double bottom,
    Duration start = Duration.zero,
  }) sync* {
    for (final timeSpan in timeSpans) {
      final end = start + timeSpan.duration;
      final left = xFromTime(start);
      final right = xFromTime(end);

      yield Rect.fromLTRB(left, top, right, bottom);

      start += timeSpan.duration;
    }
  }

  List<Sliver> getVisibleSoundSlivers() {
    return _soundClips
        .map((soundClip) => SoundSliver(
              area: Rect.fromLTWH(
                xFromTime(soundClip.startTime),
                imageSliverBottom + 8,
                widthFromDuration(soundClip.duration),
                sliverHeight,
              ),
            ))
        .toList();
  }

  /*
    Sliver menu methods:
  */

  void closeSliverMenu() {
    _selectedImageSpanIndex = null;
    notifyListeners();
  }

  void editScene() {
    _timeline.sceneSeq.currentIndex = _selectedImageSpanIndex;
    _sceneEdit = true;
    _timeline.isSceneBound = true;
    closeSliverMenu();
    notifyListeners();
  }

  void finishSceneEdit() {
    _sceneEdit = false;
    _timeline.isSceneBound = false;
    closeSliverMenu();
    notifyListeners();
  }

  // Shouldn't this be part of SceneLayer?
  void nextScenePlayMode() {
    // final scene = _timeline.currentScene;
    // final i = _timeline.sceneSeq.currentIndex;
    // final nextMode = PlayMode
    //     .values[(scene.layer.playMode.index + 1) % PlayMode.values.length];

    // _timeline.sceneSeq[i] = scene.copyWith(playMode: nextMode);
    notifyListeners();
  }

  bool get canDeleteSelected => imageSpans.length > 1;

  void deleteSelected() {
    if (_selectedImageSpanIndex == null) return;
    if (!canDeleteSelected) return;
    imageSpans.removeAt(_selectedImageSpanIndex);
    closeSliverMenu();
    notifyListeners();
  }

  Future<void> duplicateSelected() async {
    if (_selectedImageSpanIndex == null) return;
    final duplicate = isEditingScene
        ? await _duplicateFrame(selectedFrame)
        : await _duplicateScene(selectedScene);
    imageSpans.insert(_selectedImageSpanIndex + 1, duplicate);
    closeSliverMenu();
    notifyListeners();
  }

  Future<Frame> _duplicateFrame(Frame frame) async {
    final newFrame = await createNewFrame();
    return frame.copyWith(file: newFrame.file)..saveSnapshot();
  }

  // Shouldn't this be part of Scene?
  Future<Scene> _duplicateScene(Scene scene) async {
    // final duplicateFrames = await Future.wait(
    //   scene.layer.frameSeq.iterable.map((frame) => _duplicateFrame(frame)),
    // );
    // return scene.copyWith(frames: duplicateFrames);
  }

  Duration get selectedSliverStartTime => isEditingScene
      ? sceneStart + imageSpans.startTimeOf(_selectedImageSpanIndex)
      : imageSpans.startTimeOf(_selectedImageSpanIndex);

  /// Handle start time drag handle's new [updatedTimestamp].
  void onStartTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDurationToFrames(updatedTimestamp);

    final newSelectedDuration = selectedSliverEndTime - updatedTimestamp;
    final diff = newSelectedDuration - _selectedSliverDuration;
    final newPrevDuration =
        imageSpans[_selectedImageSpanIndex - 1].duration - diff;

    if (newPrevDuration < TimeSpan.singleFrameDuration) return;

    imageSpans.changeSpanDurationAt(
        _selectedImageSpanIndex - 1, newPrevDuration);
    imageSpans.changeSpanDurationAt(
        _selectedImageSpanIndex, newSelectedDuration);
    notifyListeners();
  }

  Duration get selectedSliverEndTime => isEditingScene
      ? sceneStart + imageSpans.endTimeOf(_selectedImageSpanIndex)
      : imageSpans.endTimeOf(_selectedImageSpanIndex);

  /// Handle end time drag handle's new [updatedTimestamp].
  void onEndTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDurationToFrames(updatedTimestamp);
    final newDuration = updatedTimestamp - selectedSliverStartTime;

    imageSpans.changeSpanDurationAt(_selectedImageSpanIndex, newDuration);
    notifyListeners();
  }

  /// Whether timestamp is close enough to playhead for it to snap to it.
  bool _shouldSnapToPlayhead(Duration timestamp) {
    final diff = (_timeline.playheadPosition - timestamp).abs();
    final pxDiff = durationToPx(diff, _msPerPx);
    return pxDiff <= 12;
  }

  void onSceneEndHandleDragUpdate(Duration updatedTimestamp) {
    updatedTimestamp = TimeSpan.roundDurationToFrames(updatedTimestamp);

    // Keep playhead within current scene.
    if (updatedTimestamp <= _timeline.playheadPosition) {
      updatedTimestamp = TimeSpan.ceilDurationToFrames(
        _timeline.playheadPosition + Duration(microseconds: 1),
      );
    }

    final newDuration = updatedTimestamp - sceneStart;

    _timeline.sceneSeq.changeCurrentSpanDuration(newDuration);
    notifyListeners();
  }
}
