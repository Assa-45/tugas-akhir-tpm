import 'package:flutter/material.dart';

class AppColors {
  // Primary - soft blush rose
  static const Color primary     = Color(0xFFE8A598);
  static const Color primaryLight = Color(0xFFF5D5CF);
  static const Color primaryDark  = Color(0xFFC9786A);

  // Secondary - warm camel
  static const Color secondary      = Color(0xFFD4B896);
  static const Color secondaryLight = Color(0xFFF0E0CC);

  // Accent - dusty mauve
  static const Color accent      = Color(0xFFA87890);
  static const Color accentLight = Color(0xFFE8C8D8);
  static const Color accentDark  = Color(0xFF7A5068);

  // Backgrounds
  static const Color bgMain    = Color(0xFFFDF6F0);
  static const Color bgCard    = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFFAF0EB);
  static const Color bgMuted   = Color(0xFFF2E8E0);

  // Text
  static const Color textPrimary   = Color(0xFF3D2B2B);
  static const Color textSecondary = Color(0xFF8A6E6E);
  static const Color textMuted     = Color(0xFFB8A0A0);
  static const Color textOnDark    = Color(0xFFFDFAF9);

  // Status
  static const Color success      = Color(0xFF7DB87D);
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color error        = Color(0xFFD47070);
  static const Color errorLight   = Color(0xFFFAD8D8);

  // Swatches
  static const Color swatchSienna     = Color(0xFF8B4513);
  static const Color swatchCopper     = Color(0xFFC9825A);
  static const Color swatchMoss       = Color(0xFF6B8E5A);
  static const Color swatchCamel      = Color(0xFFD4A76A);
  static const Color swatchBurgundy   = Color(0xFF6B1A2A);
  static const Color swatchTerracotta = Color(0xFFC96848);

  // Border
  static const Color border      = Color(0xFFEDD8D0);
  static const Color borderLight = Color(0xFFF5EAE4);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        background: AppColors.bgMain,
        surface: AppColors.bgCard,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.bgMain,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgMuted,
        selectedColor: AppColors.accentLight,
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        side: const BorderSide(color: AppColors.border),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.accentDark,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}