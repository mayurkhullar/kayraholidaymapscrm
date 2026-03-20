import 'package:flutter/material.dart';

import 'core/constants/app_environment.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppEnvironment.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.leadsRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
