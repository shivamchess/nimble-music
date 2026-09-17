import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/track_tile.dart';
import '../core/theme/app_colors.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final player = context.read<PlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 10)),
                  ],
                ),
                child: const Icon(Icons.water, size: 60, color: AppColors.lightTextTertiary),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Better Days', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            const Text('Playlist · Nimble', style: TextStyle(fontSize: 13, color: AppColors.lightTextSub, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text('${library.songs.length} songs · 3h 12m', style: const TextStyle(fontSize: 12, color: AppColors.lightTextTertiary)),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                  width: 180,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (library.songs.isNotEmpty) {
                        player.playSong(library.songs[0], newQueue: library.songs);
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Play', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightPillDark,
                      foregroundColor: AppColors.lightPillText,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: const Icon(Icons.favorite_border_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollException(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: library.songs.length,
              itemBuilder: (context, index) {
                final song = library.songs[index];
                return TrackTile(
                  song: song,
                  onTap: () {
                    player.playSong(song, newQueue: library.songs);
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
