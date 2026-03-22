import 'package:flutter/widgets.dart';

import 'package:kayraholidaymapscrm/core/constants/app_breakpoints.dart';

class ResponsiveUtils {
  const ResponsiveUtils._();

  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isMobile(BuildContext context) {
    return _width(context) < AppBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = _width(context);
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) {
    final width = _width(context);
    return width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  }

  static bool isWide(BuildContext context) {
    return _width(context) >= AppBreakpoints.desktop;
  }

  static double horizontalPagePadding(BuildContext context) {
    if (isWide(context)) {
      return 32;
    }
    if (isDesktop(context)) {
      return 24;
    }
    if (isTablet(context)) {
      return 20;
    }
    return 16;
  }

  static double contentMaxWidth(BuildContext context) {
    if (isWide(context)) {
      return 1440;
    }
    if (isDesktop(context)) {
      return 1280;
    }
    return double.infinity;
  }
}
