import 'package:flutter/material.dart';

class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.sidebar,
    required this.surface,
    required this.card,
    required this.cardMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  final Color background;
  final Color sidebar;
  final Color surface;
  final Color card;
  final Color cardMuted;
  final Color border;
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;
}

class AppColors {
  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFF0F7C82),
    primaryLight: Color(0xFFD9F1F2),
    primaryDark: Color(0xFF0B5968),
    background: Color(0xFFF3F6FA),
    sidebar: Color(0xFFEAF0F5),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardMuted: Color(0xFFF8FAFC),
    border: Color(0xFFD9E2EC),
    borderStrong: Color(0xFFC4D0DD),
    textPrimary: Color(0xFF102A43),
    textSecondary: Color(0xFF486581),
    textMuted: Color(0xFF7B8794),
    success: Color(0xFF2F855A),
    warning: Color(0xFFB7791F),
    error: Color(0xFFC53030),
    info: Color(0xFF2B6CB0),
  );
}
