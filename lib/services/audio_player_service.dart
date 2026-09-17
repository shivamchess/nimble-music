import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration get currentPosition => _player.position;
  Duration? get totalDuration => _player.duration;
  bool get isPlaying => _player.playing;

  Future<void> playSong(Song song, {String baseUrl = "http://127.0.0.1:54321"}) async {
    try {
      if (song.localFilePath != null && song.localFilePath!.isNotEmpty) {
        await _player.setFilePath(song.localFilePath!);
      } else {
        final streamUrl = '$baseUrl/api/stream-live?title=${Uri.encodeComponent(song.title)}&artist=${Uri.encodeComponent(song.artist)}';
        await _player.setUrl(streamUrl);
      }
      await _player.play();
    } catch (e) {
      print('AudioPlayer Error: $e');
    }
  }

  Future<void> resume() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> stop() => _player.stop();

  void dispose() {
    _player.dispose();
  }
}
