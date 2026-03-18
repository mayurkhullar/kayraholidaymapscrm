import 'package:flutter/material.dart';

class AppTypography {
  static const String? fontFamily = null;

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.55,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextTheme textTheme(Color color, Color mutedColor) {
    return TextTheme(
      displayLarge: headingLarge.copyWith(color: color),
      headlineMedium: headingMedium.copyWith(color: color),
      headlineSmall: headingSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: mutedColor),
      labelLarge: label.copyWith(color: color),
      labelMedium: label.copyWith(color: mutedColor),
    );
  }
}
