import 'package:flutter/material.dart';

import 'core/constants/app_environment.dart';
import 'core/theme/app_theme.dart';
import 'dev/dev_test_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppEnvironment.appName,
      home: const DevTestScreen(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
