import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../models/song.dart';
import '../models/lyrics_line.dart';
import '../services/nimble_audio_handler.dart';
import '../services/lyrics_service.dart';
import '../services/standalone_music_service.dart';
import '../services/database_service.dart';

class PlayerProvider extends ChangeNotifier {
  final NimbleAudioHandler _handler;
  final LyricsService _lyricsService = LyricsService();

  Song? _currentSong;
  List<Song> _queue = [];
  int _currentIndex = 0;

  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;

  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 4, seconds: 38);

  List<LyricsLine> _lyrics = [];
  int _activeLyricIndex = 0;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  Duration get position => _position;
  Duration get duration => _duration;
  List<LyricsLine> get lyrics => _lyrics;
  int get activeLyricIndex => _activeLyricIndex;

  PlayerProvider(this._handler) {
    _initListeners();
  }

  void _initListeners() {
    _handler.player.positionStream.listen((pos) {
      _position = pos;
      _updateActiveLyric(pos);
      notifyListeners();
    });

    _handler.player.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });

    _handler.playbackState.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
  }

  void _updateActiveLyric(Duration currentPos) {
    if (_lyrics.isEmpty) return;
    for (int i = 0; i < _lyrics.length; i++) {
      if (i == _lyrics.length - 1 || (_lyrics[i].time <= currentPos && _lyrics[i + 1].time > currentPos)) {
        if (_activeLyricIndex != i) {
          _activeLyricIndex = i;
          notifyListeners();
        }
        break;
      }
    }
  }

  void playSong(Song song, {List<Song>? newQueue}) async {
    _currentSong = song;
    if (newQueue != null) {
      _queue = newQueue;
      _currentIndex = _queue.indexOf(song);
    }
    _isPlaying = true;
    notifyListeners();

    await _handler.playCustomSong(song);
    _loadLyrics(song);
  }

  void _loadLyrics(Song song) async {
    // 1. Try local or Python server
    List<LyricsLine> lines = await _lyricsService.fetchLyrics(
      song.title,
      song.artist,
      localLrcPath: song.localFilePath?.replaceAll('.mp3', '.lrc'),
    );

    // 2. Fallback to direct LRCLIB on mobile
    if (lines.isEmpty) {
      lines = await StandaloneMusicService.fetchDirectLrclib(song.title, song.artist);
    }

    _lyrics = lines;
    _activeLyricIndex = 0;
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      _handler.pause();
    } else {
      _handler.play();
    }
  }

  void seek(Duration pos) {
    _handler.seek(pos);
  }

  void nextTrack() {
    if (_queue.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _queue.length;
    playSong(_queue[_currentIndex]);
  }

  void prevTrack() {
    if (_queue.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    playSong(_queue[_currentIndex]);
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void toggleFavorite() async {
    if (_currentSong != null) {
      _currentSong!.isFavorite = !_currentSong!.isFavorite;
      notifyListeners();
      await DatabaseService.instance.toggleFavorite(_currentSong!.id, _currentSong!.isFavorite);
    }
  }
}
