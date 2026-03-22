import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';

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
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideLayout =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context);
    final outerHorizontalPadding = ResponsiveUtils.horizontalPagePadding(
      context,
    );
    final outerTopPadding = isWideLayout ? AppSpacing.md : AppSpacing.sm;
    final innerHorizontalPadding = isWideLayout ? AppSpacing.md : AppSpacing.sm;
    final titleSpacing = isWideLayout ? AppSpacing.sm : AppSpacing.xs;
    final actionSpacing = isWideLayout ? AppSpacing.sm : AppSpacing.xs;
    final profileHorizontalPadding =
        isWideLayout ? AppSpacing.sm : AppSpacing.xs;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(
        outerHorizontalPadding,
        outerTopPadding,
        outerHorizontalPadding,
        0,
      ),
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: innerHorizontalPadding),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            if (showMenuButton) ...[
              _TopBarIconButton(
                onPressed: onMenuPressed,
                icon: Icons.menu_rounded,
                tooltip: 'Open navigation',
              ),
              SizedBox(width: titleSpacing),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Workspace',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Clean, focused CRM workspace',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.1,
                    ),
                  ),
                ],
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
                        vertical: 6,
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
                          SizedBox(width: titleSpacing),
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
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      splashRadius: 16,
      icon: Icon(
        icon,
        size: 17,
        color: colorScheme.onSurfaceVariant,
      ),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }
}
