import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand colors
  static const Color primary = Color.fromARGB(
    255,
    12,
    12,
    12,
  ); //Color.fromARGB(255, 234, 176, 18); sarısı
  static const Color primaryContainer = Color(0xFFF4D6DC);
  static const Color secondary = Color.fromARGB(255, 84, 75, 84);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFBFC);
  static const Color surface = Color(0xFFF8F6F7);
  static const Color outline = Color(0xFFD8D2D4);

  // Text colors
  static const Color textPrimary = Color(0xFF2B292A);
  static const Color textSecondary = Color(0xFF686164);

  // Status colors
  static const Color error = Color(0xFFB3261E);
}
