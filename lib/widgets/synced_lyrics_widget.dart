import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../core/theme/app_colors.dart';

class SyncedLyricsWidget extends StatefulWidget {
  const SyncedLyricsWidget({super.key});

  @override
  State<SyncedLyricsWidget> createState() => _SyncedLyricsWidgetState();
}

class _SyncedLyricsWidgetState extends State<SyncedLyricsWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final lyrics = player.lyrics;
    final activeIndex = player.activeLyricIndex;

    if (lyrics.isEmpty) {
      return const Center(
        child: Text(
          "Synced lyrics not available for this track.",
          style: TextStyle(color: AppColors.lightTextTertiary, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      itemCount: lyrics.length,
      itemBuilder: (context, idx) {
        final isActive = idx == activeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            lyrics[idx].text,
            style: TextStyle(
              fontSize: isActive ? 22 : 17,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.lightTextMain : AppColors.lightTextTertiary,
            ),
          ),
        );
      },
    );
  }
}
