import 'package:flutter/material.dart';

class AppTheme {
  // 1. Color Palette - Deep Teal / Nature inspired (Calm, Premium)
  static const primaryColor = Color(0xFF00695C); // Deep Teal
  static const secondaryColor = Color(0xFF4DB6AC); // Light Teal/Aqua
  static const accentColor =
      Color(0xFFFF6F00); // Amber/Orange accent for actions
  static const errorColor = Color(0xFFB00020);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFFF5F5F5);

  // 2. Light Theme Configuration
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Manrope',

    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      surface: surfaceColor,
      surfaceVariant: Color(0xFFE0F2F1), // Very light teal for containers
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor, // Use primary instead of black
      foregroundColor: Colors.white,
    ),

    // Input Decoration (TextFields)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade700),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 2,
      ),
    ),

    // Chips (for Moods/Hashtags)
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: primaryColor.withOpacity(0.2),
      secondarySelectedColor: primaryColor,
      labelStyle: const TextStyle(color: Colors.black87),
      secondaryLabelStyle:
          const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      checkmarkColor: primaryColor,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
