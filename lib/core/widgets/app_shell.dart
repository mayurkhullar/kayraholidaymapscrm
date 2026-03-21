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
    final routeName = ModalRoute.of(context)?.settings.name ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppShell.desktopBreakpoint;
        final contentPadding = EdgeInsets.fromLTRB(
          AppSpacing.xl,
          // Root-cause fix: the previous shell added a full top inset here,
          // then PageContainer added another top inset. That stacked padding
          // pushed every page header noticeably below the top bar.
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              if (isDesktop)
                AppSidebar(
                  currentRoute: routeName,
                  isCollapsed: _isSidebarCollapsed,
                  onToggleCollapse: _toggleSidebar,
                ),
              Expanded(
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
                              // Root-cause fix: forcing the scroll child to the
                              // full viewport height ignored the space already
                              // consumed by the top bar, creating an oversized
                              // content region. Keeping only maxWidth preserves
                              // top alignment without injecting extra height.
                              maxWidth: AppShell.contentMaxWidth,
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
    );
  }
}

class _AppShellSessionState {
  static bool sidebarCollapsed = false;
}
