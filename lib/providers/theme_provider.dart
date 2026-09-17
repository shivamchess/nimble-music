import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  NimbleThemeMode _mode = NimbleThemeMode.light;

  NimbleThemeMode get mode => _mode;
  ThemeData get currentTheme => AppTheme.getTheme(_mode);

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(NimbleThemeMode newMode) async {
    _mode = newMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nimble_theme', newMode.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nimble_theme');
    if (saved != null) {
      if (saved == NimbleThemeMode.dark.name) {
        _mode = NimbleThemeMode.dark;
      } else if (saved == NimbleThemeMode.dusk.name) {
        _mode = NimbleThemeMode.dusk;
      } else {
        _mode = NimbleThemeMode.light;
      }
      notifyListeners();
    }
  }
}
