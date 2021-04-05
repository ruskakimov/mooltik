extension DurationMethods on Duration {
  Duration clamp(Duration min, Duration max) => Duration(
      microseconds: this.inMicroseconds.clamp(
            min.inMicroseconds,
            max.inMicroseconds,
          ));

  Duration operator %(Duration other) =>
      Duration(microseconds: this.inMicroseconds % other.inMicroseconds);
}

extension DurationParsing on String {
  Duration parseDuration() {
    final re = RegExp(r'^(\d+):(\d{2}):(\d{2})\.(\d{6})$');
    final match = re.firstMatch(this);

    if (match == null) {
      throw Exception('Could not parse duration from $this.');
    }

    return Duration(
      hours: int.parse(match.group(1)),
      minutes: int.parse(match.group(2)),
      seconds: int.parse(match.group(3)),
      microseconds: int.parse(match.group(4)),
    );
  }
}
