import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.title,
    super.key,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  final String title;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showMenuButton) ...[
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open navigation',
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search',
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Notifications',
            ),
            const SizedBox(width: AppSpacing.md),
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
              child: Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
