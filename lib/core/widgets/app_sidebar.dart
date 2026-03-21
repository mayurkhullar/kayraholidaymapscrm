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

  static const double expandedWidth = 240;
  static const double collapsedWidth = 72;
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
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            isCollapsed ? AppSpacing.md : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment:
                isCollapsed
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              _SidebarHeader(
                isCollapsed: isCollapsed,
                onToggleCollapse: onToggleCollapse,
              ),
              SizedBox(height: isCollapsed ? AppSpacing.lg : AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: AppNavigationItems.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
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

    return SizedBox(
      height: 48,
      child: isCollapsed
          ? IconButton(
              onPressed: onToggleCollapse,
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Expand sidebar',
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    'Kayra CRM',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: onToggleCollapse,
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: 'Collapse sidebar',
                ),
              ],
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
      color: isActive
          ? colorScheme.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (!isActive) {
            Navigator.of(context).pushReplacementNamed(item.route);
          }
        },
        child: AnimatedContainer(
          duration: AppSidebar._animationDuration,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSpacing.md : AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 20,
                color:
                    isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color:
                          isActive ? colorScheme.primary : colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!isCollapsed) {
      return itemContent;
    }

    return Tooltip(
      message: item.label,
      waitDuration: const Duration(milliseconds: 300),
      child: itemContent,
    );
  }
}
