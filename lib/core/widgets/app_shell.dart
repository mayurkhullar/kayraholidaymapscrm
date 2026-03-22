import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';
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
    final horizontalPagePadding = ResponsiveUtils.horizontalPagePadding(context);
    final contentMaxWidth = ResponsiveUtils.contentMaxWidth(context);
    final shellTopPadding = isDesktopLayout ? AppSpacing.md : AppSpacing.sm;
    final shellBottomPadding = isDesktopLayout ? AppSpacing.sm : AppSpacing.xs;
    final contentPadding = isDesktopLayout ? AppSpacing.lg : AppSpacing.md;

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
                        title: widget.pageTitle,
                        showMenuButton: !isDesktopLayout,
                        onMenuPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPagePadding,
                            shellTopPadding,
                            horizontalPagePadding,
                            shellBottomPadding,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: contentMaxWidth,
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
                                    contentPadding,
                                    contentPadding,
                                    contentPadding,
                                    AppSpacing.sm,
                                  ),
                                  child: widget.child,
                                ),
                              ),
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
