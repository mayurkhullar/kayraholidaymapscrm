import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';
import 'page_container.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.pageTitle,
    required this.child,
    super.key,
  });

  final String pageTitle;
  final Widget child;
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

    final isDesktopLayout =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context);
    final shellTopPadding = AppSpacing.xs;
    final shellBottomPadding = isDesktopLayout ? AppSpacing.sm : AppSpacing.sm;
    final contentPadding = isDesktopLayout ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktopLayout
          ? null
          : Drawer(
              width: 280,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              child: AppSidebar(
                currentRoute: routeName,
                isCollapsed: false,
                onToggleCollapse: () {},
                closeOnNavigate: true,
              ),
            ),
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktopLayout)
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
                        pageTitle: widget.pageTitle,
                        showMenuButton: !isDesktopLayout,
                        onMenuPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      Expanded(
                        child: PageContainer(
                          topSpacing: shellTopPadding,
                          bottomSpacing: shellBottomPadding,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x120F172A),
                                  blurRadius: 26,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                contentPadding,
                                contentPadding,
                                contentPadding,
                                contentPadding,
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
  }
}

class _AppShellSessionState {
  static bool sidebarCollapsed = false;
}
