import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../core/theme/app_colors.dart';
import '../views/now_playing_screen.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const NowPlayingScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 38,
                height: 38,
                color: AppColors.lightSurfaceSubtle,
                child: const Icon(Icons.music_note, color: AppColors.lightTextTertiary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.lightTextSub, fontSize: 11),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
              onPressed: player.togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}
