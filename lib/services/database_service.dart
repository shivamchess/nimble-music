import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/song.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _db;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'nimble_vault.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE songs (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            duration TEXT,
            duration_seconds INTEGER,
            local_path TEXT,
            cover_url TEXT,
            has_lyrics INTEGER,
            is_favorite INTEGER,
            added_at INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE playlists (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            created_at INTEGER
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_songs_title ON songs (title);
        ''');
      },
    );
  }

  Future<void> insertOrUpdateSong(Song song) async {
    final db = await database;
    await db.insert(
      'songs',
      {
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'duration': song.duration,
        'duration_seconds': song.durationSeconds,
        'local_path': song.localFilePath,
        'cover_url': song.coverUrl,
        'has_lyrics': song.hasLyrics ? 1 : 0,
        'is_favorite': song.isFavorite ? 1 : 0,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('songs', orderBy: 'title ASC');

    return maps.map((m) => Song(
      id: m['id'] as String,
      title: m['title'] as String,
      artist: m['artist'] as String,
      duration: m['duration'] as String? ?? '3:30',
      durationSeconds: m['duration_seconds'] as int? ?? 210,
      localFilePath: m['local_path'] as String?,
      coverUrl: m['cover_url'] as String?,
      hasLyrics: (m['has_lyrics'] as int? ?? 0) == 1,
      isFavorite: (m['is_favorite'] as int? ?? 0) == 1,
    )).toList();
  }

  Future<void> toggleFavorite(String songId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'songs',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [songId],
    );
  }

  Future<void> deleteSong(String songId) async {
    final db = await database;
    await db.delete('songs', where: 'id = ?', whereArgs: [songId]);
  }
}
