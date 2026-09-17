import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

enum NimbleThemeMode { light, dark, dusk }

class AppTheme {
  static ThemeData getTheme(NimbleThemeMode mode) {
    switch (mode) {
      case NimbleThemeMode.dark:
        return _buildDarkTheme();
      case NimbleThemeMode.dusk:
        return _buildDuskTheme();
      case NimbleThemeMode.light:
      default:
        return _buildLightTheme();
    }
  }

  static ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightCanvas,
      primaryColor: AppColors.lightPillDark,
      cardColor: AppColors.lightSurface,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: AppColors.lightTextMain,
        displayColor: AppColors.lightTextMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextMain),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkCanvas,
      primaryColor: AppColors.darkPillDark,
      cardColor: AppColors.darkSurface,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.darkTextMain,
        displayColor: AppColors.darkTextMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextMain),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData _buildDuskTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.duskCanvas,
      primaryColor: AppColors.duskPillDark,
      cardColor: AppColors.duskSurface,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: AppColors.duskTextMain,
        displayColor: AppColors.duskTextMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.duskTextMain),
      ),
      useMaterial3: true,
    );
  }
}
