Duration pxToDuration(double offset, double msPerPx) =>
    Duration(milliseconds: (offset * msPerPx).round());

double durationToPx(Duration duration, double msPerPx) =>
    duration.inMilliseconds / msPerPx;
