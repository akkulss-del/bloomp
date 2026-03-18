import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B8CE7);
  static const Color primaryDark = Color(0xFF5F4FD1);
  
  // Secondary
  static const Color secondary = Color(0xFF00D9A3);
  static const Color secondaryLight = Color(0xFF4DFFCD);
  static const Color secondaryDark = Color(0xFF00A67E);
  
  // Accent
  static const Color accent = Color(0xFFFF6B9D);
  static const Color accentLight = Color(0xFFFFB6D0);
  static const Color accentDark = Color(0xFFD14876);
  
  // Status
  static const Color success = Color(0xFF00D9A3);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF6B9D);
  static const Color info = Color(0xFF00BCD4);
  
  // Neutral
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey900 = Color(0xFF2D2D2D);
  static const Color grey800 = Color(0xFF3D3D3D);
  static const Color grey700 = Color(0xFF5C5C5C);
  static const Color grey600 = Color(0xFF7A7A7A);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey200 = Color(0xFFE8E8E8);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color purple = Color(0xFF9C27B0);
  static const Color red = Color(0xFFE53935);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
}