import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D47A1); // Deep Ocean Blue
  static const Color accentColor = Color(0xFFD4AF37); // Subtle Gold/Bronze
  static const Color textPrimaryColor = Color(0xFF1F2937); // Dark Charcoal
  static const Color textSecondaryColor = Color(0xFF6B7280); // Cool Grey
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure White (Pearl)
  static const Color cardColor = Color(0xFFF9FAFB); // Slightly off-white for depth

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        backgroundColor: backgroundColor,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
      fontFamily: 'Inter', // Default clean sans-serif
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, height: 1.2),
        titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -0.5),
        titleMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: textSecondaryColor, fontSize: 14, height: 1.5),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
