import 'package:flutter/material.dart';

import '../constants/app_enums.dart';
import '../theme/app_spacing.dart';

class StatusTag extends StatelessWidget {
  const StatusTag({
    required this.label,
    required this.type,
    super.key,
  });

  final String label;
  final StatusTagType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = _resolveColors(colorScheme);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  _StatusTagColors _resolveColors(ColorScheme colorScheme) {
    switch (type) {
      case StatusTagType.neutral:
        return _StatusTagColors(
          background: colorScheme.surfaceContainerHighest,
          foreground: colorScheme.onSurfaceVariant,
        );
      case StatusTagType.info:
        return _StatusTagColors(
          background: colorScheme.secondaryContainer,
          foreground: colorScheme.secondary,
        );
      case StatusTagType.success:
        return _StatusTagColors(
          background: colorScheme.tertiaryContainer,
          foreground: colorScheme.tertiary,
        );
      case StatusTagType.warning:
        return _StatusTagColors(
          background: colorScheme.primaryContainer.withValues(alpha: 0.24),
          foreground: colorScheme.onPrimaryContainer,
        );
      case StatusTagType.error:
        return _StatusTagColors(
          background: colorScheme.errorContainer,
          foreground: colorScheme.error,
        );
    }
  }
}

class _StatusTagColors {
  const _StatusTagColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}
