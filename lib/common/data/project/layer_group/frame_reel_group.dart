import 'package:flutter/material.dart';
import 'package:mooltik/common/data/project/frame_interface.dart';
import 'package:mooltik/common/data/project/layer_group/combine_frames.dart';
import 'package:mooltik/common/data/sequence/sequence.dart';
import 'package:mooltik/drawing/data/frame/frame.dart';
import 'package:mooltik/drawing/data/frame_reel_model.dart';

/// Wrapper around `FrameReelModel` to keep grouped layers in sync.
class FrameReelGroup extends ChangeNotifier implements FrameReelModel {
  FrameReelGroup({
    required this.activeReel,
    required this.group,
  });

  final FrameReelModel activeReel;
  final List<FrameReelModel> group;

  @override
  Sequence<Frame> get frameSeq => activeReel.frameSeq;

  @override
  Frame get currentFrame => activeReel.currentFrame;

  @override
  FrameInterface get deleteDialogFrame =>
      combineFrames(group.map((reel) => reel.currentFrame));

  @override
  int get currentIndex => activeReel.currentIndex;

  @override
  void setCurrent(int index) {
    group.forEach((reel) => reel.setCurrent(index));
    notifyListeners();
  }

  @override
  Future<void> appendFrame() async {
    await Future.wait(group.map((reel) => reel.appendFrame()));
    notifyListeners();
  }

  @override
  Future<void> addBeforeCurrent() async {
    await Future.wait(group.map((reel) => reel.addBeforeCurrent()));
    notifyListeners();
  }

  @override
  Future<void> addAfterCurrent() async {
    await Future.wait(group.map((reel) => reel.addAfterCurrent()));
    notifyListeners();
  }

  @override
  Future<void> duplicateCurrent() async {
    await Future.wait(group.map((reel) => reel.duplicateCurrent()));
    notifyListeners();
  }

  @override
  bool get canDeleteCurrent => activeReel.canDeleteCurrent;

  @override
  void deleteCurrent() {
    group.forEach((reel) => reel.deleteCurrent());
    notifyListeners();
  }
}
