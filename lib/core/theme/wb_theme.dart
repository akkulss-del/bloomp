import 'package:flutter/material.dart';

class WBTheme {
  // Фирменные цвета Wildberries
  static const Color wbPurple = Color(0xFF9C27B0);
  static const Color wbBg = Color(0xFFF6F6F9);
  static const Color wbPurpleDark = Color(0xFF7B1FA2);
  static const Color wbPink = Color(0xFFC2185B);
  static const Color wbPinkLight = Color(0xFFE91E63);

  // Градиенты
  static const LinearGradient wbGradient = LinearGradient(
    colors: [Color(0xFF7B1FA2), Color(0xFFC2185B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient wbGradientVertical = LinearGradient(
    colors: [Color(0xFF7B1FA2), Color(0xFFC2185B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient wbGradientLight = LinearGradient(
    colors: [Color(0xFFE1BEE7), Color(0xFFF8BBD0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Дополнительные цвета
  static const Color wbSuccess = Color(0xFF4CAF50);
  static const Color wbWarning = Color(0xFFFF9800);
  static const Color wbError = Color(0xFFF44336);

  // Тени
  static List<BoxShadow> wbShadow = [
    BoxShadow(
      color: wbPurple.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> wbShadowLight = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Скругления
  static const BorderRadius wbBorderRadius =
      BorderRadius.all(Radius.circular(12));
  static const BorderRadius wbBorderRadiusSmall =
      BorderRadius.all(Radius.circular(8));
  static const BorderRadius wbBorderRadiusLarge =
      BorderRadius.all(Radius.circular(16));
}