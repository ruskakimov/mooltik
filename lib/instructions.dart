import 'dart:ui';

abstract class Instruction {}

abstract class DelayedInstruction extends Instruction {
  DelayedInstruction(this.delay);

  final Duration delay;
}

abstract class SwitchTool extends Instruction {}

class TeleportTo extends Instruction {
  TeleportTo(this.to);

  final Offset to;
}

class DragTo extends DelayedInstruction {
  DragTo(this.to, Duration delay) : super(delay);

  final Offset to;
}
