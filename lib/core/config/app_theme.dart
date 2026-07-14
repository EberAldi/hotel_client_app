import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const terracotta = Color(0xFFC1502E);
  static const oaxacaBlue = Color(0xFF1B4B6E);
  static const cempasuchil = Color(0xFFE8A317);
  static const canteraGreen = Color(0xFF5C7A5C);
  static const cream = Color(0xFFF5EEE2);
  static const ink = Color(0xFF2B2420);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.terracotta,
        secondary: AppColors.cempasuchil,
        tertiary: AppColors.oaxacaBlue,
        surface: AppColors.cream,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 34, color: AppColors.ink, height: 1.15,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          fontSize: 24, color: AppColors.ink,
        ),
        titleLarge: GoogleFonts.dmSerifDisplay(
          fontSize: 20, color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.nunitoSans(color: AppColors.ink, fontSize: 15),
        bodyMedium: GoogleFonts.nunitoSans(color: AppColors.ink.withOpacity(0.75)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.ink,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          fontSize: 20, color: AppColors.ink,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: AppColors.ink.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}