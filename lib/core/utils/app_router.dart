import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/leads/presentation/leads_screen.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String leadsRoute = '/leads';
  static const String clientsRoute = '/clients';
  static const String companiesRoute = '/companies';
  static const String travelersRoute = '/travelers';
  static const String travelFilesRoute = '/travel-files';
  static const String reportsRoute = '/reports';
  static const String settingsRoute = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case dashboardRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case leadsRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const LeadsScreen(),
          settings: settings,
        );
      case clientsRoute:
        return _placeholderRoute(settings, title: 'Clients');
      case companiesRoute:
        return _placeholderRoute(settings, title: 'Companies');
      case travelersRoute:
        return _placeholderRoute(settings, title: 'Travelers');
      case travelFilesRoute:
        return _placeholderRoute(settings, title: 'Travel Files');
      case reportsRoute:
        return _placeholderRoute(settings, title: 'Reports');
      case settingsRoute:
        return _placeholderRoute(settings, title: 'Settings');
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }

  static Route<dynamic> _placeholderRoute(
    RouteSettings settings, {
    required String title,
  }) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _PlaceholderModuleScreen(title: title),
    );
  }
}

class _PlaceholderModuleScreen extends StatelessWidget {
  const _PlaceholderModuleScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppShell(
      pageTitle: title,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Module content',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This workspace is not available yet.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
