import 'package:flutter/material.dart';

class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
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
  final Color surface;
  final Color card;
  final Color border;

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
    primary: Color(0xFF0F8B8D),
    primaryLight: Color(0xFF5FBFC1),
    primaryDark: Color(0xFF0A5E73),
    background: Color(0xFFF4F7FB),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFCFDFE),
    border: Color(0xFFD9E2EC),
    textPrimary: Color(0xFF102A43),
    textSecondary: Color(0xFF486581),
    textMuted: Color(0xFF829AB1),
    success: Color(0xFF2F9E78),
    warning: Color(0xFFD98E04),
    error: Color(0xFFD64545),
    info: Color(0xFF2B6CB0),
  );

  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFF4EC9C1),
    primaryLight: Color(0xFF82E3DB),
    primaryDark: Color(0xFF1B7F86),
    background: Color(0xFF0B1520),
    surface: Color(0xFF101C2A),
    card: Color(0xFF152434),
    border: Color(0xFF243B53),
    textPrimary: Color(0xFFF0F4F8),
    textSecondary: Color(0xFFBCCCDC),
    textMuted: Color(0xFF829AB1),
    success: Color(0xFF5BC99A),
    warning: Color(0xFFF0B44D),
    error: Color(0xFFFF7B7B),
    info: Color(0xFF63B3ED),
  );
}
