import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/lyrics_line.dart';
import '../core/constants/api_constants.dart';

class LyricsService {
  final String baseUrl;

  LyricsService({this.baseUrl = ApiConstants.localhostUrl});

  // Parse .lrc string into timestamped lines
  static List<LyricsLine> parseLrc(String lrcContent) {
    final List<LyricsLine> lines = [];
    final regExp = RegExp(r'\[(\d{2}:\d{2}(?:\.\d{1,3})?)\](.*)');

    for (final line in LineSplitter.split(lrcContent)) {
      final match = regExp.firstMatch(line.trim());
      if (match != null) {
        final timeStr = match.group(1)!;
        final textStr = match.group(2)!.trim();
        if (textStr.isNotEmpty) {
          lines.add(LyricsLine.fromLrc(timeStr, textStr));
        }
      }
    }

    lines.sort((a, b) => a.time.compareTo(b.time));
    return lines;
  }

  // Fetch lyrics from local file or backend
  Future<List<LyricsLine>> fetchLyrics(String title, String artist, {String? localLrcPath}) async {
    // 1. Check local .lrc file if on disk
    if (localLrcPath != null) {
      final file = File(localLrcPath);
      if (await file.exists()) {
        try {
          final content = await file.readAsString();
          final parsed = parseLrc(content);
          if (parsed.isNotEmpty) return parsed;
        } catch (_) {}
      }
    }

    // 2. Fetch from Python backend
    try {
      final url = Uri.parse('$baseUrl${ApiConstants.endpointLyrics}?title=${Uri.encodeComponent(title)}&artist=${Uri.encodeComponent(artist)}');
      final resp = await http.get(url).timeout(const Duration(seconds: 4));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data['lines'] != null) {
          final List<dynamic> rawLines = data['lines'];
          return rawLines.map((l) {
            if (l is Map && l['time'] != null && l['text'] != null) {
              return LyricsLine.fromLrc(l['time'].toString(), l['text'].toString());
            }
            return LyricsLine(time: Duration.zero, text: (l is Map ? l['text'] : l).toString());
          }).toList();
        }
      }
    } catch (_) {}

    return [];
  }
}
