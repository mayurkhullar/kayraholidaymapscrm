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
  static const double contentMaxWidth = 1280;

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
        final contentPadding = EdgeInsets.fromLTRB(
          isDesktop ? AppSpacing.xl : AppSpacing.md,
          isDesktop ? AppSpacing.lg : AppSpacing.md,
          isDesktop ? AppSpacing.xl : AppSpacing.md,
          AppSpacing.xl,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF0A1019),
          body: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1019),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.2),
                  const Color(0xFF0A1019),
                ],
              ),
            ),
            child: Row(
              children: [
                if (isDesktop)
                  AppSidebar(
                    currentRoute: routeName,
                    isCollapsed: _isSidebarCollapsed,
                    onToggleCollapse: _toggleSidebar,
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? AppSpacing.lg : 0,
                      0,
                      0,
                      0,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF111926),
                        border: Border(
                          left: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: isDesktop ? 0.24 : 0,
                            ),
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 30,
                            offset: const Offset(-10, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AppTopBar(
                            title: widget.pageTitle,
                            showMenuButton: !isDesktop,
                            onMenuPressed: () {},
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                padding: contentPadding,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: AppShell.contentMaxWidth,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF151F2E),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: colorScheme.outlineVariant
                                            .withValues(alpha: 0.22),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.22,
                                          ),
                                          blurRadius: 32,
                                          offset: const Offset(0, 16),
                                        ),
                                      ],
                                    ),
                                    child: widget.child,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppShellSessionState {
  static bool sidebarCollapsed = false;
}
