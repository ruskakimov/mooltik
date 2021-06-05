import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/project.dart';
import 'package:mooltik/common/data/project/scene.dart';
import 'package:mooltik/common/data/project/scene_layer.dart';
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
    required TimelineModel timeline,
    required List<SoundClip>? soundClips,
    required SharedPreferences? sharedPreferences,
    required this.createNewFrame,
  })  : _timeline = timeline,
        _soundClips = soundClips ?? [],
        _preferences = sharedPreferences,
        _msPerPx = sharedPreferences?.getDouble(_msPerPxKey) ?? 10 {
    _prevMsPerPx = _msPerPx;
    timeline.addListener(notifyListeners);
  }

  SharedPreferences? _preferences;
  final TimelineModel _timeline;
  final List<SoundClip> _soundClips;
  final CreateNewFrame? createNewFrame;

  bool get isEditingScene => _sceneEdit;
  bool _sceneEdit = false;

  double get msPerPx => _msPerPx;
  double _msPerPx;
  late double _prevMsPerPx;
  double? _scaleOffset;
  late Offset _prevFocalPoint;

  double get timelineWidth => durationToPx(_timeline.totalDuration, _msPerPx);

  void onScaleStart(ScaleStartDetails details) {
    _prevMsPerPx = _msPerPx;
    _prevFocalPoint = details.localFocalPoint;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    _scaleOffset ??= 1 - details.scale;
    _setScale(_prevMsPerPx / (details.scale + _scaleOffset!));

    final diff = (details.localFocalPoint - _prevFocalPoint);
    var timeDiff = pxToDuration(-diff.dx, _msPerPx);
    _timeline.scrub(timeDiff);

    removeSliverSelection();

    _prevFocalPoint = details.localFocalPoint;

    notifyListeners();
  }

  void _setScale(double newMsPerPx) {
    _msPerPx = newMsPerPx.clamp(1.0, 100.0);
    _preferences!.setDouble(_msPerPxKey, _msPerPx);
  }

  void onScaleEnd(ScaleEndDetails details) {
    _scaleOffset = null;
  }

  void onTapUp(TapUpDetails details) {
    final sliver = _getSliverUnderPosition(details.localPosition);
    selectSliver(sliver?.id);
  }

  Sliver? _getSliverUnderPosition(Offset position) {
    bool withinRow(double rowTop, double rowBottom) =>
        position.dy >= rowTop && position.dy <= rowBottom;

    for (final row in _renderedSliverRows) {
      final rowTop = row.first.area.top;
      final rowBottom = row.first.area.bottom;

      if (withinRow(rowTop, rowBottom)) {
        return row.firstWhereOrNull(
          (sliver) => sliver.area.contains(position),
        );
      }
    }
    return null;
  }

  /// Size of the timeline view.
  /// Update before painting or gesture detection.
  Size size = Size.zero;

  double get _midX => size.width / 2;

  double get sliverHeight => 56;
  double get sliverGap => 8;

  int get sliverRows =>
      isEditingScene ? _timeline.currentScene.layers.length + 1 : 2;

  List<SceneLayer> get sceneLayers => _timeline.currentScene.layers;

  // TODO: Sound sequence support
  List<Sequence<TimeSpan>> get sequenceRows => isEditingScene
      ? sceneLayers.map((layer) => layer.frameSeq).toList()
      : [_timeline.sceneSeq];

  double get viewHeight =>
      sliverRows * sliverHeight + (sliverRows + 1) * sliverGap;

  double rowTop(int rowIndex) =>
      (rowIndex + 1) * sliverGap + rowIndex * sliverHeight;

  double rowMiddle(int rowIndex) =>
      (rowTop(rowIndex) + rowBottom(rowIndex)) / 2;

  double rowBottom(int rowIndex) => rowTop(rowIndex) + sliverHeight;

  double xFromTime(Duration time) =>
      _midX + durationToPx(time - _timeline.playheadPosition, _msPerPx);

  Duration timeFromX(double x) =>
      _timeline.playheadPosition + pxToDuration(x - _midX, msPerPx);

  double widthFromDuration(Duration duration) =>
      durationToPx(duration, _msPerPx);

  Duration get sceneStart => _timeline.currentSceneStart;

  Duration get sceneEnd => _timeline.currentSceneEnd;

  late List<List<Sliver>> _renderedSliverRows;

  List<List<Sliver>> getSliverRows() {
    final rows = <List<Sliver>>[];
    int rowIndex = 0;

    void addRow(List<Sliver> row) {
      rows.add(row);
      rowIndex++;
    }

    if (isEditingScene) {
      for (final layer in _timeline.currentScene.layers) {
        final frames = layer.frameSeq.iterable.followedBy(
          layer.getGhostFrames(_timeline.currentScene.duration),
        );
        final frameRow = frameSliverRow(
          areas: timeSpanAreas(
            timeSpans: frames,
            top: rowTop(rowIndex),
            bottom: rowBottom(rowIndex),
            start: sceneStart,
          ),
          frames: frames,
          numberOfRealFrames: layer.frameSeq.length,
          rowIndex: rowIndex,
        ).toList();

        addRow(frameRow);
      }
    } else {
      final sceneSeq = _timeline.sceneSeq;
      final sceneRow = sceneSliverRow(
        areas: timeSpanAreas(
          timeSpans: sceneSeq.iterable,
          top: rowTop(rowIndex),
          bottom: rowBottom(rowIndex),
        ),
        scenes: sceneSeq.iterable,
        rowIndex: rowIndex,
      ).toList();

      addRow(sceneRow);
    }

    if (_soundClips.isNotEmpty) {
      addRow(soundSliverRow(
        rowTop: rowTop(rowIndex),
        rowBottom: rowBottom(rowIndex),
      ).toList());
    }

    _renderedSliverRows = rows;
    return rows;
  }

  Iterable<ImageSliver> frameSliverRow({
    required Iterable<Rect> areas,
    required Iterable<Frame> frames,
    required int numberOfRealFrames,
    required int rowIndex,
  }) sync* {
    int frameIndex = 0;
    final areaIt = areas.iterator;
    final frameIt = frames.iterator;

    while (areaIt.moveNext() && frameIt.moveNext()) {
      final area = areaIt.current;
      final frame = frameIt.current;
      final isGhostFrame = frameIndex >= numberOfRealFrames;

      yield ImageSliver(
        area: area,
        thumbnail: frame.snapshot,
        id: isGhostFrame ? null : SliverId(rowIndex, frameIndex),
        opacity: isGhostFrame ? 0.3 : 1,
      );

      frameIndex++;
    }
  }

  Iterable<VideoSliver> sceneSliverRow({
    required Iterable<Rect> areas,
    required Iterable<Scene> scenes,
    required int rowIndex,
  }) sync* {
    int sceneIndex = 0;
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
        id: SliverId(rowIndex, sceneIndex),
      );

      sceneIndex++;
    }
  }

  Iterable<SoundSliver> soundSliverRow({
    required double rowTop,
    required double rowBottom,
  }) {
    return _soundClips.map((soundClip) => SoundSliver(
          area: Rect.fromLTRB(
            xFromTime(soundClip.startTime),
            rowTop,
            xFromTime(soundClip.endTime),
            rowBottom,
          ),
        ));
  }

  Iterable<Rect> timeSpanAreas({
    required Iterable<TimeSpan> timeSpans,
    required double top,
    required double bottom,
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

  // ===========================
  // Selected sliver operations:
  // ===========================

  SliverId? get selectedSliverId => _selectedSliverId;
  SliverId? _selectedSliverId;

  Sequence<TimeSpan>? get selectedSliverSequence => _selectedSliverId != null
      ? sequenceRows[_selectedSliverId!.rowIndex]
      : null;

  void selectSliver(SliverId? sliverId) {
    if (_timeline.isPlaying) _timeline.pause();
    _selectedSliverId = sliverId;
    notifyListeners();
  }

  void removeSliverSelection() => selectSliver(null);

  bool get showSliverMenu => _selectedSliverId != null;

  double get selectedSliverMidY => rowMiddle(_selectedSliverId!.rowIndex);

  bool get showResizeStartHandle =>
      showSliverMenu && _selectedSliverId!.spanIndex != 0;

  bool get showResizeEndHandle => showSliverMenu;

  TimeSpan get selectedSpan =>
      selectedSliverSequence![_selectedSliverId!.spanIndex];
  Frame get selectedFrame => selectedSpan as Frame;
  Scene get selectedScene => selectedSpan as Scene;

  Duration get _selectedSliverDuration => selectedSpan.duration;

  String get selectedSliverDurationLabel =>
      durationToLabel(_selectedSliverDuration);

  void editScene() {
    if (isEditingScene) return;
    _timeline.sceneSeq.currentIndex = _selectedSliverId!.spanIndex;
    _sceneEdit = true;
    _timeline.isSceneBound = true;
    removeSliverSelection();
    notifyListeners();
  }

  void finishSceneEdit() {
    if (!isEditingScene) return;
    _sceneEdit = false;
    _timeline.isSceneBound = false;
    removeSliverSelection();
    notifyListeners();
  }

  void nextScenePlayModeForLayer(int layerIndex) {
    final layer = sceneLayers[layerIndex];
    layer.nextPlayMode();
    notifyListeners();
  }

  void toggleLayerVisibility(int layerIndex) {
    final layer = sceneLayers[layerIndex];
    layer.setVisibility(!layer.visible);
    notifyListeners();
  }

  bool get canDeleteSelected => selectedSliverSequence != null
      ? selectedSliverSequence!.length > 1
      : false;

  void deleteSelected() {
    if (_selectedSliverId == null) return;
    if (!canDeleteSelected) return;
    selectedSliverSequence!.removeAt(_selectedSliverId!.spanIndex);
    removeSliverSelection();
    notifyListeners();
  }

  Future<void> duplicateSelected() async {
    if (_selectedSliverId == null) return;
    final duplicate = isEditingScene
        ? await _duplicateFrame(selectedFrame)
        : await _duplicateScene(selectedScene);
    selectedSliverSequence!.insert(_selectedSliverId!.spanIndex + 1, duplicate);
    removeSliverSelection();
    notifyListeners();
  }

  Future<Frame> _duplicateFrame(Frame frame) async {
    final newFrame = await createNewFrame!();
    return frame.copyWith(file: newFrame.file)..saveSnapshot();
  }

  Future<Scene> _duplicateScene(Scene scene) async {
    final duplicateLayers =
        await Future.wait(scene.layers.map((layer) => _duplicateLayer(layer)));
    return scene.copyWith(layers: duplicateLayers);
  }

  Future<SceneLayer> _duplicateLayer(SceneLayer sceneLayer) async {
    final duplicateFrames = await Future.wait(
      sceneLayer.frameSeq.iterable.map((frame) => _duplicateFrame(frame)),
    );
    return SceneLayer(Sequence(duplicateFrames), sceneLayer.playMode);
  }

  Duration get selectedSliverStartTime => isEditingScene
      ? sceneStart +
          selectedSliverSequence!.startTimeOf(_selectedSliverId!.spanIndex)
      : selectedSliverSequence!.startTimeOf(_selectedSliverId!.spanIndex);

  /// Handle start time drag handle's new [updatedTimestamp].
  void onStartTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDurationToFrames(updatedTimestamp);

    final newSelectedDuration = selectedSliverEndTime - updatedTimestamp;
    final diff = newSelectedDuration - _selectedSliverDuration;
    final newPrevDuration =
        selectedSliverSequence![_selectedSliverId!.spanIndex - 1].duration - diff;

    if (newPrevDuration < TimeSpan.singleFrameDuration) return;

    selectedSliverSequence!.changeSpanDurationAt(
        _selectedSliverId!.spanIndex - 1, newPrevDuration);
    selectedSliverSequence!.changeSpanDurationAt(
        _selectedSliverId!.spanIndex, newSelectedDuration);
    notifyListeners();
  }

  Duration get selectedSliverEndTime => isEditingScene
      ? sceneStart +
          selectedSliverSequence!.endTimeOf(_selectedSliverId!.spanIndex)
      : selectedSliverSequence!.endTimeOf(_selectedSliverId!.spanIndex);

  /// Handle end time drag handle's new [updatedTimestamp].
  void onEndTimeHandleDragUpdate(Duration updatedTimestamp) {
    if (_shouldSnapToPlayhead(updatedTimestamp)) {
      updatedTimestamp = _timeline.playheadPosition;
    }
    updatedTimestamp = TimeSpan.roundDurationToFrames(updatedTimestamp);
    final newDuration = updatedTimestamp - selectedSliverStartTime;

    selectedSliverSequence!.changeSpanDurationAt(
        _selectedSliverId!.spanIndex, newDuration);
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
