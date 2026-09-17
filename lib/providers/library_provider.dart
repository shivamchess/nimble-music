import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';

class LibraryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService.instance;

  List<Song> _songs = [];
  bool _isLoading = false;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;

  LibraryProvider() {
    loadLibrary();
  }

  Future<void> loadLibrary() async {
    _isLoading = true;
    notifyListeners();

    // 1. Instant loading from SQLite Vault Cache
    final cachedSongs = await _dbService.getAllSongs();
    if (cachedSongs.isNotEmpty) {
      _songs = cachedSongs;
      _isLoading = false;
      notifyListeners();
    }

    // 2. Background scan: phone local storage
    final localSongs = await StorageService.scanLocalMusic();
    if (localSongs.isNotEmpty) {
      _songs = localSongs;
      for (final s in localSongs) {
        await _dbService.insertOrUpdateSong(s);
      }
    } else {
      // 3. Background sync: Python desktop server
      final serverSongs = await _apiService.fetchServerSongs();
      if (serverSongs.isNotEmpty) {
        _songs = serverSongs;
        for (final s in serverSongs) {
          await _dbService.insertOrUpdateSong(s);
        }
      } else if (_songs.isEmpty) {
        _songs = _getDefaultMockSongs();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Song> _getDefaultMockSongs() {
    return [
      Song(id: '1', title: 'Sunrise', artist: 'Tom Odell', duration: '3:12', durationSeconds: 192, hasLyrics: true),
      Song(id: '2', title: 'Higher', artist: 'RÜFÜS DU SOL', duration: '4:17', durationSeconds: 257, hasLyrics: true),
      Song(id: '3', title: 'Good Days', artist: 'SZA', duration: '4:38', durationSeconds: 278, hasLyrics: true),
      Song(id: '4', title: 'Bloom', artist: 'The Paper Kites', duration: '3:28', durationSeconds: 208, hasLyrics: false),
      Song(id: '5', title: 'Ocean Eyes', artist: 'Billie Eilish', duration: '3:20', durationSeconds: 200, hasLyrics: true),
    ];
  }
}
