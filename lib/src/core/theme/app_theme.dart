import 'package:flutter/material.dart';

class AppTheme {
  // 1. Định nghĩa bảng màu (Color Palette)
  static const primaryColor = Color(0xFF6200EE); // Màu tím chủ đạo
  static const secondaryColor = Color(0xFF03DAC6); // Màu xanh ngọc
  static const errorColor = Color(0xFFB00020);

  // 2. Cấu hình Light Theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),

    // Cấu hình Font chữ mặc định
    fontFamily: 'Roboto', // Hoặc font bạn thích

    // Cấu hình Input (TextField) mặc định cho toàn app
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Cấu hình Nút bấm (ElevatedButton) mặc định
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, // Màu chữ
        minimumSize: const Size(double.infinity, 50), // Chiều cao chuẩn 50
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
