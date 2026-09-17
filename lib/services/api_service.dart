import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = ApiConstants.localhostUrl});

  // Fetch songs from python server
  Future<List<Song>> fetchServerSongs() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl${ApiConstants.endpointSongs}')).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((item) => Song.fromJson(item, baseUrl)).toList();
      }
    } catch (_) {}
    return [];
  }

  // Trigger batch download
  Future<bool> startDownload(String url) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl${ApiConstants.endpointDownload}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'url': url}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Trigger lyrics sync
  Future<bool> syncLyrics() async {
    try {
      final res = await http.post(Uri.parse('$baseUrl${ApiConstants.endpointSyncLyrics}'));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
