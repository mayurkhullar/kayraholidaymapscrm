import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.pageTitle,
    required this.child,
    super.key,
  });

  final String pageTitle;
  final Widget child;

  static const double desktopBreakpoint = 1024;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isSidebarCollapsed = _AppShellSessionState.sidebarCollapsed;

  @override
  void initState() {
    super.initState();
    _isSidebarCollapsed = _AppShellSessionState.sidebarCollapsed;
  }

  void _toggleSidebar() {
    final nextValue = !_isSidebarCollapsed;

    setState(() {
      _isSidebarCollapsed = nextValue;
    });

    _AppShellSessionState.sidebarCollapsed = nextValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final routeName = ModalRoute.of(context)?.settings.name ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppShell.desktopBreakpoint;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              if (isDesktop)
                AppSidebar(
                  currentRoute: routeName,
                  isCollapsed: _isSidebarCollapsed,
                  onToggleCollapse: _toggleSidebar,
                ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      left: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: isDesktop ? 0.3 : 0,
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      AppTopBar(
                        title: widget.pageTitle,
                        showMenuButton: !isDesktop,
                        onMenuPressed: () {},
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: colorScheme.surface,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              isDesktop ? AppSpacing.lg : AppSpacing.md,
                              isDesktop ? AppSpacing.lg : AppSpacing.md,
                              isDesktop ? AppSpacing.lg : AppSpacing.md,
                              AppSpacing.lg,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppShellSessionState {
  static bool sidebarCollapsed = false;
}
