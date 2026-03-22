import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colors: AppColors.light,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colors: AppColors.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppColorPalette colors,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: Colors.white,
      primaryContainer: colors.primaryLight,
      onPrimaryContainer: colors.primaryDark,
      secondary: colors.info,
      onSecondary: Colors.white,
      secondaryContainer: colors.primaryLight.withValues(alpha: 0.18),
      onSecondaryContainer: colors.textPrimary,
      tertiary: colors.success,
      onTertiary: Colors.white,
      tertiaryContainer: colors.success.withValues(alpha: 0.16),
      onTertiaryContainer: colors.textPrimary,
      error: colors.error,
      onError: Colors.white,
      errorContainer: colors.error.withValues(alpha: 0.14),
      onErrorContainer: colors.textPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.card,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.border,
      outlineVariant: colors.border.withValues(alpha: 0.78),
      shadow: Colors.black.withValues(
        alpha: brightness == Brightness.light ? 0.08 : 0.28,
      ),
      scrim: Colors.black.withValues(alpha: 0.45),
      inverseSurface: brightness == Brightness.light
          ? const Color(0xFF102A43)
          : const Color(0xFFF4F7FB),
      onInverseSurface: brightness == Brightness.light
          ? const Color(0xFFF4F7FB)
          : const Color(0xFF102A43),
      inversePrimary: colors.primaryLight,
      surfaceTint: Colors.transparent,
    );

    final textTheme = AppTypography.textTheme(
      colors.textPrimary,
      colors.textMuted,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.card,
      dividerColor: colors.border,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: AppTypography.headingSmall.copyWith(
          color: colors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.border.withValues(alpha: 0.4)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light ? colors.surface : colors.card,
        hintStyle: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
        labelStyle: AppTypography.label.copyWith(color: colors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border.withValues(alpha: 0.72)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.label,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          textStyle: AppTypography.label,
          side: BorderSide(color: colors.border.withValues(alpha: 0.72)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border.withValues(alpha: 0.68),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
