import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'playlist_detail_screen.dart';
import '../widgets/mini_player_bar.dart';
import '../core/theme/app_colors.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text("Search Catalog", style: TextStyle(fontWeight: FontWeight.w700)))),
    const PlaylistDetailScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 64,
            child: MiniPlayerBar(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.lightBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: AppColors.lightPillDark,
          unselectedItemColor: AppColors.lightTextTertiary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Your Library'),
          ],
        ),
      ),
    );
  }
}
