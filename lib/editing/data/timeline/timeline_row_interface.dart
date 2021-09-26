import 'package:mooltik/common/data/sequence/time_span.dart';

abstract class TimelineRowInterface {
  int get clipCount;
  Iterable<TimeSpan> get clips;

  TimeSpan clipAt(int index);
  void deleteAt(int index);
  Future<void> duplicateAt(int index);
  void changeDurationAt(int index, Duration newDuration);
  Duration startTimeOf(int index);
  Duration endTimeOf(int index);
}
