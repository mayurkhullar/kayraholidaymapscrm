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
        final mainPadding = isDesktop ? AppSpacing.lg : AppSpacing.md;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: isDesktop
              ? null
              : Drawer(
                  width: 280,
                  backgroundColor: colorScheme.surface,
                  surfaceTintColor: Colors.transparent,
                  child: AppSidebar(
                    currentRoute: routeName,
                    isCollapsed: false,
                    onToggleCollapse: () {},
                  ),
                ),
          body: Builder(
            builder: (context) {
              return SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isDesktop)
                      AppSidebar(
                        currentRoute: routeName,
                        isCollapsed: _isSidebarCollapsed,
                        onToggleCollapse: _toggleSidebar,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTopBar(
                            title: widget.pageTitle,
                            showMenuButton: !isDesktop,
                            onMenuPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                mainPadding,
                                AppSpacing.md,
                                mainPadding,
                                AppSpacing.xs,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0D0F172A),
                                      blurRadius: 22,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    isDesktop ? AppSpacing.lg : AppSpacing.md,
                                    isDesktop ? AppSpacing.lg : AppSpacing.md,
                                    isDesktop ? AppSpacing.lg : AppSpacing.md,
                                    AppSpacing.xs,
                                  ),
                                  child: widget.child,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AppShellSessionState {
  static bool sidebarCollapsed = false;
}
