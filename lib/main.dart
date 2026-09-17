import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'services/nimble_audio_handler.dart';
import 'providers/player_provider.dart';
import 'providers/library_provider.dart';
import 'providers/theme_provider.dart';
import 'views/onboarding_screen.dart';

late NimbleAudioHandler globalAudioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize production background audio service
  globalAudioHandler = await AudioService.init(
    builder: () => NimbleAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.nimble.music.channel.audio',
      androidNotificationChannelName: 'Nimble Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider(globalAudioHandler)),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
      ],
      child: const NimbleApp(),
    ),
  );
}

class NimbleApp extends StatelessWidget {
  const NimbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Nimble Music',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const OnboardingScreen(),
    );
  }
}
