import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.pageTitle,
    required this.child,
    super.key,
  });

  final String pageTitle;
  final Widget child;

  static const double _desktopBreakpoint = 1024;
  static const double _contentMaxWidth = 1280;

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              if (isDesktop) AppSidebar(currentRoute: routeName),
              Expanded(
                child: Column(
                  children: [
                    AppTopBar(
                      title: pageTitle,
                      showMenuButton: !isDesktop,
                      onMenuPressed: () {},
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _contentMaxWidth,
                            ),
                            child: child,
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
