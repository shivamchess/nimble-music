import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import '../models/lyrics_line.dart';
import 'lyrics_service.dart';

/// Standalone mobile engine that queries music streams and lyrics
/// directly on the mobile device even when no Python PC server is reachable!
class StandaloneMusicService {
  static const String lrclibApi = "https://lrclib.net/api";

  // Search public music streams directly on mobile
  static Future<List<Song>> searchOnlineSongs(String query) async {
    final List<Song> results = [];
    try {
      final url = Uri.parse("https://pipedapi.kavin.rocks/search?q=${Uri.encodeComponent(query)}&filter=music_songs");
      final resp = await http.get(url).timeout(const Duration(seconds: 4));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final title = item['title'] as String? ?? 'Unknown';
          final uploader = item['uploaderName'] as String? ?? 'Artist';
          final durSec = item['duration'] as int? ?? 200;
          final m = durSec ~/ 60;
          final s = durSec % 60;
          final durStr = '$m:${s < 10 ? '0' : ''}$s';
          final thumb = item['thumbnail'] as String?;
          final urlStr = item['url'] as String? ?? '';

          results.add(Song(
            id: urlStr,
            title: title,
            artist: uploader,
            duration: durStr,
            durationSeconds: durSec,
            coverUrl: thumb,
            hasLyrics: true,
          ));
        }
      }
    } catch (_) {}

    return results;
  }

  // Fetch synced lyrics directly from LRCLIB on mobile
  static Future<List<LyricsLine>> fetchDirectLrclib(String trackName, String artistName) async {
    try {
      final url = Uri.parse("$lrclibApi/get?track_name=${Uri.encodeComponent(trackName)}&artist_name=${Uri.encodeComponent(artistName)}");
      final resp = await http.get(url, headers: {'User-Agent': 'NimbleMobile/1.0'}).timeout(const Duration(seconds: 4));

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        final syncedLyrics = data['syncedLyrics'] as String?;
        if (syncedLyrics != null && syncedLyrics.isNotEmpty) {
          return LyricsService.parseLrc(syncedLyrics);
        }
      }
    } catch (_) {}

    return [];
  }
}
