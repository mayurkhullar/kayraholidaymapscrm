import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/clients/presentation/client_detail_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/leads/presentation/lead_detail_screen.dart';
import '../../features/leads/presentation/leads_screen.dart';
import '../../features/travelers/presentation/traveler_detail_screen.dart';
import '../../features/travelers/presentation/travelers_screen.dart';
import '../../features/travel_files/presentation/travel_file_detail_screen.dart';
import '../../features/travel_files/presentation/travel_files_screen.dart';
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
    final routeName = settings.name ?? '';

    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case dashboardRoute:
        return _shellRoute(
          settings,
          pageTitle: 'Dashboard',
          currentRoute: dashboardRoute,
          child: const DashboardScreen(),
        );
      case leadsRoute:
        return _shellRoute(
          settings,
          pageTitle: 'Leads',
          currentRoute: leadsRoute,
          child: const LeadsScreen(),
        );
      case clientsRoute:
        return _placeholderRoute(
          settings,
          title: 'Clients',
          currentRoute: clientsRoute,
        );
      case companiesRoute:
        return _placeholderRoute(
          settings,
          title: 'Companies',
          currentRoute: companiesRoute,
        );
      case travelersRoute:
        return _shellRoute(
          settings,
          pageTitle: 'Travelers',
          currentRoute: travelersRoute,
          child: const TravelersScreen(),
        );
      case travelFilesRoute:
        return _shellRoute(
          settings,
          pageTitle: 'Travel Files',
          currentRoute: travelFilesRoute,
          child: const TravelFilesScreen(),
        );
      case reportsRoute:
        return _placeholderRoute(
          settings,
          title: 'Reports',
          currentRoute: reportsRoute,
        );
      case settingsRoute:
        return _placeholderRoute(
          settings,
          title: 'Settings',
          currentRoute: settingsRoute,
        );
      default:
        final leadId = _extractPathParameter(routeName, baseRoute: leadsRoute);
        if (leadId != null) {
          return _shellRoute(
            settings,
            pageTitle: 'Lead Details',
            currentRoute: leadsRoute,
            child: LeadDetailScreen(leadId: leadId),
          );
        }

        final clientId = _extractPathParameter(routeName, baseRoute: clientsRoute);
        if (clientId != null) {
          return _shellRoute(
            settings,
            pageTitle: 'Client Details',
            currentRoute: clientsRoute,
            child: ClientDetailScreen(clientId: clientId),
          );
        }

        final travelerId = _extractPathParameter(routeName, baseRoute: travelersRoute);
        if (travelerId != null) {
          return _shellRoute(
            settings,
            pageTitle: 'Traveler Details',
            currentRoute: travelersRoute,
            child: TravelerDetailScreen(travelerId: travelerId),
          );
        }
        final travelFileId = _extractPathParameter(routeName, baseRoute: travelFilesRoute);
        if (travelFileId != null) {
          return _shellRoute(
            settings,
            pageTitle: 'Travel File Details',
            currentRoute: travelFilesRoute,
            child: TravelFileDetailScreen(travelFileId: travelFileId),
          );
        }


        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }

  static String leadsDetailRoute(String leadId) => '$leadsRoute/$leadId';

  static String clientDetailRoute(String clientId) => '$clientsRoute/$clientId';

  static String travelerDetailRoute(String travelerId) =>
      '$travelersRoute/$travelerId';

  static String travelFileDetailRoute(String travelFileId) =>
      '$travelFilesRoute/$travelFileId';

  static String? _extractPathParameter(
    String routeName, {
    required String baseRoute,
  }) {
    if (!routeName.startsWith('$baseRoute/')) {
      return null;
    }

    final parameter = routeName.substring(baseRoute.length + 1).trim();
    if (parameter.isEmpty || parameter.contains('/')) {
      return null;
    }

    return Uri.decodeComponent(parameter);
  }

  static Route<dynamic> _shellRoute(
    RouteSettings settings, {
    required String pageTitle,
    required String currentRoute,
    required Widget child,
  }) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => AppShell(
        pageTitle: pageTitle,
        currentRoute: currentRoute,
        child: child,
      ),
    );
  }

  static Route<dynamic> _placeholderRoute(
    RouteSettings settings, {
    required String title,
    required String currentRoute,
  }) {
    return _shellRoute(
      settings,
      pageTitle: title,
      currentRoute: currentRoute,
      child: _PlaceholderModuleScreen(title: title),
    );
  }
}

class _PlaceholderModuleScreen extends StatelessWidget {
  const _PlaceholderModuleScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
    );
  }
}
