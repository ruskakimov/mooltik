Duration parseDuration(String source) {
  final re = RegExp(r'^(\d+):(\d{2}):(\d{2})\.(\d{6})$');
  final match = re.firstMatch(source);
  return Duration(
    hours: int.parse(match.group(1)),
    minutes: int.parse(match.group(2)),
    seconds: int.parse(match.group(3)),
    microseconds: int.parse(match.group(4)),
  );
}
