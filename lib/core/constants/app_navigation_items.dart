import 'package:flutter/material.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}

class AppNavigationItems {
  static const List<AppNavigationItem> items = [
    AppNavigationItem(
      label: 'Dashboard',
      route: '/dashboard',
      icon: Icons.grid_view_rounded,
    ),
    AppNavigationItem(
      label: 'Leads',
      route: '/leads',
      icon: Icons.track_changes_rounded,
    ),
    AppNavigationItem(
      label: 'Clients',
      route: '/clients',
      icon: Icons.people_alt_rounded,
    ),
    AppNavigationItem(
      label: 'Companies',
      route: '/companies',
      icon: Icons.apartment_rounded,
    ),
    AppNavigationItem(
      label: 'Travelers',
      route: '/travelers',
      icon: Icons.luggage_rounded,
    ),
    AppNavigationItem(
      label: 'Travel Files',
      route: '/travel-files',
      icon: Icons.folder_copy_rounded,
    ),
    AppNavigationItem(
      label: 'Reports',
      route: '/reports',
      icon: Icons.insert_chart_outlined_rounded,
    ),
    AppNavigationItem(
      label: 'Settings',
      route: '/settings',
      icon: Icons.settings_outlined,
    ),
  ];
}
