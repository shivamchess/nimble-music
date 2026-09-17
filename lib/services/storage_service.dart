import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class StorageService {
  // Request storage permissions on Android/iOS
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final audioStatus = await Permission.audio.request();
      if (audioStatus.isGranted) return true;
      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    }
    return true;
  }

  // Scan local audio files in Download folder
  static Future<List<Song>> scanLocalMusic() async {
    final List<Song> foundSongs = [];
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download/Spotify_Liked_Songs');
        if (!await dir.exists()) {
          dir = Directory('/storage/emulated/0/Download');
        }
      } else {
        dir = await getDownloadsDirectory();
      }

      if (dir != null && await dir.exists()) {
        final List<FileSystemEntity> entities = dir.listSync();
        for (final entity in entities) {
          if (entity is File && entity.path.toLowerCase().endsWith('.mp3')) {
            final fileName = entity.uri.pathSegments.last;
            final base = fileName.replaceAll('.mp3', '');
            String title = base;
            String artist = 'Offline Artist';

            if (base.contains(' - ')) {
              final parts = base.split(' - ');
              artist = parts[0].trim();
              title = parts[1].trim();
            }

            final lrcFile = File(entity.path.replaceAll('.mp3', '.lrc'));
            final hasLyrics = await lrcFile.exists();

            foundSongs.add(Song(
              id: entity.path,
              title: title,
              artist: artist,
              duration: '3:30',
              localFilePath: entity.path,
              hasLyrics: hasLyrics,
            ));
          }
        }
      }
    } catch (e) {
      print('Storage scan error: $e');
    }
    return foundSongs;
  }
}
