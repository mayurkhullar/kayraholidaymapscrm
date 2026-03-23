import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.pageTitle,
    super.key,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  final String pageTitle;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideLayout =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context);
    final horizontalPadding = ResponsiveUtils.horizontalPagePadding(context);
    final actionSpacing = isWideLayout ? AppSpacing.sm : AppSpacing.xs;
    final profileHorizontalPadding =
        isWideLayout ? AppSpacing.sm : AppSpacing.xs;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.98),
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.16),
            ),
          ),
        ),
        child: Row(
          children: [
            if (showMenuButton) ...[
              _TopBarIconButton(
                onPressed: onMenuPressed,
                icon: Icons.menu_rounded,
                tooltip: 'Open navigation',
              ),
              SizedBox(width: actionSpacing),
            ],
            Expanded(
              child: Text(
                pageTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            SizedBox(width: actionSpacing),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideLayout ? 240 : 156,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TopBarIconButton(
                      onPressed: () {},
                      icon: Icons.search_rounded,
                      tooltip: 'Search',
                    ),
                    SizedBox(width: actionSpacing),
                    _TopBarIconButton(
                      onPressed: () {},
                      icon: Icons.notifications_none_rounded,
                      tooltip: 'Notifications',
                    ),
                    SizedBox(width: actionSpacing),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: profileHorizontalPadding,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                colorScheme.primary.withValues(alpha: 0.12),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 15,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: actionSpacing),
                          Text(
                            'Admin',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      splashRadius: 15,
      icon: Icon(
        icon,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
