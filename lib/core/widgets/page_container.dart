import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  static const double _maxWidth = 1228;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 1200
            ? AppSpacing.xl
            : constraints.maxWidth >= 768
                ? AppSpacing.lg
                : AppSpacing.md;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.xl,
                horizontalPadding,
                AppSpacing.xl,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
