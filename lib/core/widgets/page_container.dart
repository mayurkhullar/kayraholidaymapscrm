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
        final verticalPadding = constraints.maxWidth >= 768
            ? AppSpacing.xs
            : AppSpacing.sm;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
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
