import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/filter_chip_bar.dart';
import '../providers/library_provider.dart';
import '../providers/player_provider.dart';
import '../core/theme/app_colors.dart';
import 'playlist_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final player = context.read<PlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nimble', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning,', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                  Text("Let's find your next favorite.", style: TextStyle(fontSize: 18, color: AppColors.lightTextSub, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilterChipBar(onFilterSelected: (filter) {}),
            const SizedBox(height: 24),
            _buildSectionHead(context, 'Recently Played', () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaylistDetailScreen()));
            }),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRecentCard(context, 'Midnight Drive', 'Playlist · Nimble'),
                  const SizedBox(width: 16),
                  _buildRecentCard(context, 'Better Days', 'Playlist · Nimble'),
                  const SizedBox(width: 16),
                  _buildRecentCard(context, 'Good Vibes', 'Playlist · Nimble'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHead(context, 'Made for You', () {}),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildWideMixCard('Discover Weekly', 'Your weekly mix of fresh music, handpicked for you.', () {
                    if (library.songs.isNotEmpty) {
                      player.playSong(library.songs[0], newQueue: library.songs);
                    }
                  }),
                  const SizedBox(height: 14),
                  _buildWideMixCard('Chill Vibes', 'Relax and unwind with these mellow tracks.', () {
                    if (library.songs.length > 1) {
                      player.playSong(library.songs[1], newQueue: library.songs);
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHead(BuildContext context, String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('See all', style: TextStyle(color: AppColors.lightTextTertiary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCard(BuildContext context, String title, String sub) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaylistDetailScreen()));
      },
      child: SizedBox(
        width: 124,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.album_rounded, size: 48, color: AppColors.lightTextTertiary),
            ),
            const SizedBox(height: 8),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.lightTextTertiary, fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildWideMixCard(String title, String desc, VoidCallback onPlay) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.music_note, color: AppColors.lightTextTertiary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.lightTextSub, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded, size: 36, color: AppColors.lightPillDark),
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
