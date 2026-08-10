import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String primaryFont = 'Poppins';
  static const String logoFont = 'Pacifico';

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(
      fontFamily: primaryFont,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w500),
  );

  const AppTypography._();
}
