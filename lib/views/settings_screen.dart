import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_colors.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _spatialAudio = true;
  bool _bassBoost = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Audio', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('THEME & AESTHETICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextTertiary)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildThemeOption('Nimble Light', AppColors.lightCanvas, themeProvider.mode == NimbleThemeMode.light, () {
                themeProvider.setTheme(NimbleThemeMode.light);
              }),
              const SizedBox(width: 10),
              _buildThemeOption('Obsidian Dark', AppColors.darkCanvas, themeProvider.mode == NimbleThemeMode.dark, () {
                themeProvider.setTheme(NimbleThemeMode.dark);
              }),
              const SizedBox(width: 10),
              _buildThemeOption('Warm Dusk', AppColors.duskCanvas, themeProvider.mode == NimbleThemeMode.dusk, () {
                themeProvider.setTheme(NimbleThemeMode.dusk);
              }),
            ],
          ),
          const SizedBox(height: 28),
          const Text('SPOTIFY BATCH INGEST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextTertiary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Paste song / playlist link...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.lightTextTertiary),
                    filled: true,
                    fillColor: AppColors.lightSurfaceSubtle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final url = _urlController.text.trim();
                  if (url.isNotEmpty) {
                    final ok = await ApiService().startDownload(url);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ok ? 'Download started in background!' : 'Download request queued')),
                      );
                      _urlController.clear();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPillDark,
                  foregroundColor: AppColors.lightPillText,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: const Text('Download', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('AUDIO & SOUNDSTAGE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextTertiary)),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Spatial 3D Audio', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
            subtitle: const Text('Concert soundstage widening', style: TextStyle(color: AppColors.lightTextSub, fontSize: 12)),
            value: _spatialAudio,
            activeColor: AppColors.emeraldActive,
            onChanged: (v) => setState(() => _spatialAudio = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Deep Bass Boost', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
            subtitle: const Text('Low-frequency acoustic enhancement', style: TextStyle(color: AppColors.lightTextSub, fontSize: 12)),
            value: _bassBoost,
            activeColor: AppColors.emeraldActive,
            onChanged: (v) => setState(() => _bassBoost = v),
          ),
          const SizedBox(height: 20),
          const Text('OFFLINE VAULT & LYRICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextTertiary)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final ok = await ApiService().syncLyrics();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'Syncing lyrics for all vault songs...' : 'Lyrics sync triggered')),
                );
              }
            },
            icon: const Icon(Icons.sync_rounded),
            label: const Text('Sync All Vault Lyrics (.lrc)'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String name, Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.lightPillDark : AppColors.lightBorder, width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              CircleAvatar(radius: 14, backgroundColor: color),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
