import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: child);
  }
}
