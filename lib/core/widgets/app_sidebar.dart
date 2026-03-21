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
    final toggleButton = _SidebarToggleButton(
      isCollapsed: isCollapsed,
      onPressed: onToggleCollapse,
    );

    return SizedBox(
      height: 48,
      child:
          isCollapsed
              ? Center(child: toggleButton)
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
                ? colorScheme.primary.withValues(alpha: 0.10)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: 0.22)
                  : colorScheme.outlineVariant,
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
        hoverColor: colorScheme.primary.withValues(alpha: 0.06),
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
      preferBelow: false,
      child: itemContent,
    );
  }
}
