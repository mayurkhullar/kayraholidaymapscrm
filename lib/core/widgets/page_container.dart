import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
    this.topSpacing = 0,
    this.bottomSpacing = 0,
  });

  final Widget child;
  final double topSpacing;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.horizontalPagePadding(context);
    final contentMaxWidth = ResponsiveUtils.contentMaxWidth(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topSpacing,
          horizontalPadding,
          bottomSpacing,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: contentMaxWidth,
          ),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
