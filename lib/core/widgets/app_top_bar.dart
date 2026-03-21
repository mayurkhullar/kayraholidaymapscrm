import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    this.title,
    super.key,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  final String? title;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 6,
          ),
          child: SizedBox(
            height: 34,
            child: Row(
              children: [
                if (showMenuButton) ...[
                  _TopBarIconButton(
                    onPressed: onMenuPressed,
                    icon: Icons.menu_rounded,
                    tooltip: 'Open navigation',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                const Spacer(),
                _TopBarIconButton(
                  onPressed: () {},
                  icon: Icons.search_rounded,
                  tooltip: 'Search',
                ),
                const SizedBox(width: 2),
                _TopBarIconButton(
                  onPressed: () {},
                  icon: Icons.notifications_none_rounded,
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: AppSpacing.md),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 15,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      splashRadius: 17,
      icon: Icon(
        icon,
        size: 19,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.92),
      ),
    );
  }
}
