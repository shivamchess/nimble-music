class LyricsLine {
  final Duration time;
  final String text;

  LyricsLine({required this.time, required this.text});

  factory LyricsLine.fromLrc(String timestamp, String text) {
    // timestamp format mm:ss.xx
    int minutes = 0;
    double seconds = 0.0;
    try {
      final parts = timestamp.split(':');
      if (parts.length == 2) {
        minutes = int.parse(parts[0]);
        seconds = double.parse(parts[1]);
      }
    } catch (_) {}

    final totalMs = ((minutes * 60 + seconds) * 1000).toInt();
    return LyricsLine(time: Duration(milliseconds: totalMs), text: text);
  }
}
