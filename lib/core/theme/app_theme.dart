import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(colors: AppColors.light);

  static ThemeData _buildTheme({required AppColorPalette colors}) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: Colors.white,
      primaryContainer: colors.primaryLight,
      onPrimaryContainer: colors.primaryDark,
      secondary: colors.info,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE5EEF9),
      onSecondaryContainer: colors.textPrimary,
      tertiary: colors.success,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFE6F4EC),
      onTertiaryContainer: colors.textPrimary,
      error: colors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFFFEEBEC),
      onErrorContainer: colors.textPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.cardMuted,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.borderStrong,
      outlineVariant: colors.border,
      shadow: const Color(0x140F172A),
      scrim: Colors.black54,
      inverseSurface: colors.textPrimary,
      onInverseSurface: colors.surface,
      inversePrimary: colors.primaryLight,
      surfaceTint: Colors.transparent,
    );

    final textTheme = AppTypography.textTheme(
      colors.textPrimary,
      colors.textMuted,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.card,
      dividerColor: colors.border,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.card,
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
        shadowColor: const Color(0x140F172A),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
        labelStyle: AppTypography.label.copyWith(color: colors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 1.4),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          textStyle: AppTypography.label,
          side: BorderSide(color: colors.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(colors.borderStrong),
        trackColor: WidgetStatePropertyAll(colors.background),
        radius: const Radius.circular(999),
      ),
    );
  }
}
