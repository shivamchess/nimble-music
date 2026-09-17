import 'package:flutter/material.dart';
import '../models/song.dart';
import '../core/theme/app_colors.dart';

class TrackTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const TrackTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 42,
                height: 42,
                color: AppColors.lightSurfaceSubtle,
                child: const Icon(Icons.music_note, color: AppColors.lightTextTertiary, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.lightTextSub, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (song.hasLyrics) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.emeraldActive.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'LYRICS',
                  style: TextStyle(color: AppColors.emeraldActive, fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              song.duration,
              style: const TextStyle(color: AppColors.lightTextTertiary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, size: 18, color: AppColors.lightTextTertiary),
          ],
        ),
      ),
    );
  }
}
