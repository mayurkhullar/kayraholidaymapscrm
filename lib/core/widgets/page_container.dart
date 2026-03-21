import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  static const double _maxWidth = 1120;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 1200
            ? AppSpacing.xxl
            : constraints.maxWidth >= 768
                ? AppSpacing.xl
                : AppSpacing.lg;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                // Root-cause fix: PageContainer was adding its own top padding
                // on top of AppShell's top scroll padding, so page headers sat
                // too low across the shared layout.
                0,
                horizontalPadding,
                AppSpacing.md,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
