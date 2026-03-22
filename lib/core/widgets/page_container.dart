import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.contentMaxWidth(context),
        ),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
