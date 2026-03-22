import 'package:flutter/material.dart';

import '../constants/app_navigation_items.dart';
import '../theme/app_spacing.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.currentRoute,
    required this.isCollapsed,
    required this.onToggleCollapse,
    super.key,
  });

  static const double expandedWidth = 248;
  static const double collapsedWidth = 80;
  static const Duration _animationDuration = Duration(milliseconds: 180);

  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOutCubic,
      width: isCollapsed ? collapsedWidth : expandedWidth,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0F5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment:
                    isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  _SidebarHeader(
                    isCollapsed: isCollapsed,
                    onToggleCollapse: onToggleCollapse,
                  ),
                  SizedBox(height: isCollapsed ? AppSpacing.lg : AppSpacing.xl),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: AppNavigationItems.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final item = AppNavigationItems.items[index];
                        final isActive = currentRoute == item.route;

                        return _SidebarItem(
                          item: item,
                          isActive: isActive,
                          isCollapsed: isCollapsed,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final toggleButton = _SidebarToggleButton(
      isCollapsed: isCollapsed,
      onPressed: onToggleCollapse,
    );

    if (isCollapsed) {
      return SizedBox(
        height: 56,
        width: double.infinity,
        child: Center(child: toggleButton),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.dashboard_customize_rounded,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kayra CRM',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Operations suite',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          toggleButton,
        ],
      ),
    );
  }
}

class _SidebarToggleButton extends StatelessWidget {
  const _SidebarToggleButton({
    required this.isCollapsed,
    required this.onPressed,
  });

  final bool isCollapsed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
      visualDensity: VisualDensity.compact,
      splashRadius: 18,
      icon: Icon(
        isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
  });

  final AppNavigationItem item;
  final bool isActive;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final itemContent = Material(
      color: isActive ? colorScheme.primary.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        hoverColor: colorScheme.surface.withValues(alpha: 0.6),
        onTap: () {
          if (!isActive) {
            Navigator.of(context).pushReplacementNamed(item.route);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 20,
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color:
                          isActive ? colorScheme.primary : colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(message: item.label, child: itemContent);
    }

    return itemContent;
  }
}
