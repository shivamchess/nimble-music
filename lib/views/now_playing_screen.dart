import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../widgets/synced_lyrics_widget.dart';
import '../core/theme/app_colors.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _showLyrics = false;

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _showLyrics
                    ? const SyncedLyricsWidget()
                    : Center(
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
                          decoration: BoxDecoration(
                            color: AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: const [
                              BoxShadow(color: Color(0x1A000000), blurRadius: 40, offset: Offset(0, 20)),
                            ],
                          ),
                          child: const Icon(Icons.water, size: 100, color: AppColors.lightTextTertiary),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song?.title ?? 'Good Days',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song?.artist ?? 'SZA',
                          style: const TextStyle(fontSize: 15, color: AppColors.lightTextSub, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      song?.isFavorite == true ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: song?.isFavorite == true ? AppColors.heartRed : AppColors.lightTextMain,
                    ),
                    onPressed: player.toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      trackHeight: 3,
                      activeTrackColor: AppColors.lightPillDark,
                      inactiveTrackColor: AppColors.lightSurfaceSubtle,
                      thumbColor: AppColors.lightPillDark,
                    ),
                    child: Slider(
                      value: player.position.inSeconds.toDouble().clamp(0.0, player.duration.inSeconds.toDouble()),
                      max: player.duration.inSeconds.toDouble() > 0 ? player.duration.inSeconds.toDouble() : 278,
                      onChanged: (val) {
                        player.seek(Duration(seconds: val.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(player.position), style: const TextStyle(fontSize: 12, color: AppColors.lightTextTertiary, fontWeight: FontWeight.w600)),
                        Text(_formatDuration(player.duration), style: const TextStyle(fontSize: 12, color: AppColors.lightTextTertiary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle_rounded, color: player.isShuffle ? AppColors.emeraldActive : AppColors.lightTextMain),
                    onPressed: player.toggleShuffle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 30),
                    onPressed: player.prevTrack,
                  ),
                  GestureDetector(
                    onTap: player.togglePlay,
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: AppColors.lightPillDark,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x2A000000), blurRadius: 20, offset: Offset(0, 8)),
                        ],
                      ),
                      child: Icon(
                        player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: AppColors.lightPillText,
                        size: 32,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 30),
                    onPressed: player.nextTrack,
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat_rounded, color: player.isRepeat ? AppColors.emeraldActive : AppColors.lightTextMain),
                    onPressed: player.toggleRepeat,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.airplay_rounded, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(_showLyrics ? Icons.music_note_rounded : Icons.lyrics_rounded, size: 22),
                    onPressed: () {
                      setState(() => _showLyrics = !_showLyrics);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s < 10 ? '0' : ''}$s';
  }
}
