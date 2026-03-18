import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/services/app_startup_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartupService.initialize();
  runApp(const App());
}
