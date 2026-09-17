import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class NimbleAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  Song? _currentSong;

  Song? get currentSong => _currentSong;
  AudioPlayer get player => _player;

  NimbleAudioHandler() {
    _initAudioSession();
    _broadcastAudioState();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Auto-pause when headphones are unplugged to prevent sound blasting
    session.becomingNoisyEventStream.listen((_) {
      pause();
    });

    // Handle incoming phone calls / interruptions
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        pause();
      } else {
        if (event.type != AudioInterruptionType.unknown) {
          play();
        }
      }
    });
  }

  void _broadcastAudioState() {
    // Pipe just_audio playback state into audio_service for lockscreen controls
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final isPlaying = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: isPlaying,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });

    // Update media duration
    _player.durationStream.listen((Duration? dur) {
      if (dur != null && mediaItem.value != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: dur));
      }
    });
  }

  Future<void> playCustomSong(Song song, {String baseUrl = "http://127.0.0.1:54321"}) async {
    _currentSong = song;

    // Publish to system MediaSession for Android lockscreen & notification
    final item = MediaItem(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: "Nimble Music",
      duration: Duration(seconds: song.durationSeconds),
      artUri: song.coverUrl != null ? Uri.tryParse(song.coverUrl!) : null,
    );
    mediaItem.add(item);

    try {
      if (song.localFilePath != null && song.localFilePath!.isNotEmpty) {
        await _player.setFilePath(song.localFilePath!);
      } else {
        final streamUrl = '$baseUrl/api/stream-live?title=${Uri.encodeComponent(song.title)}&artist=${Uri.encodeComponent(song.artist)}';
        await _player.setUrl(streamUrl);
      }
      await _player.play();
    } catch (e) {
      print('NimbleAudioHandler playback error: $e');
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }
}
