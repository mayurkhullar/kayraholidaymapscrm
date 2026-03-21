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
        color: const Color(0xFF0B121B),
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.09),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? AppSpacing.sm : AppSpacing.lg,
            vertical: isCollapsed ? AppSpacing.md : AppSpacing.lg,
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
                  padding: EdgeInsets.zero,
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
        color: colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.dashboard_customize_rounded,
              color: colorScheme.primary.withValues(alpha: 0.92),
              size: 19,
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
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.64),
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

class _SidebarToggleButton extends StatefulWidget {
  const _SidebarToggleButton({
    required this.isCollapsed,
    required this.onPressed,
  });

  final bool isCollapsed;
  final VoidCallback onPressed;

  @override
  State<_SidebarToggleButton> createState() => _SidebarToggleButtonState();
}

class _SidebarToggleButtonState extends State<_SidebarToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tooltip = widget.isCollapsed ? 'Expand sidebar' : 'Collapse sidebar';

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 250),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: AppSidebar._animationDuration,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : colorScheme.outlineVariant.withValues(alpha: 0.12),
            ),
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            visualDensity: VisualDensity.compact,
            splashRadius: 18,
            icon: AnimatedSwitcher(
              duration: AppSidebar._animationDuration,
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween<double>(begin: 0.9, end: 1).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                widget.isCollapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                key: ValueKey(widget.isCollapsed),
              ),
            ),
          ),
        ),
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
        hoverColor: colorScheme.surface.withValues(alpha: 0.12),
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
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? colorScheme.primary.withValues(alpha: 0.18)
                  : Colors.transparent,
            ),
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
                color: isActive
                    ? colorScheme.primary.withValues(alpha: 0.96)
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isActive
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.8),
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
      waitDuration: const Duration(milliseconds: 250),
      child: itemContent,
    );
  }
}
